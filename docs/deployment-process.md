# Terraform GitHub Actions deployment

## Workflow overview

- `.github/workflows/terraform-pr.yml` runs for pull requests targeting `main` when `terraform/**` changes. It checks formatting, initializes dev and bootstrap with `-backend=false`, and validates both. It attempts a dev plan without refreshing cloud state; if the Google provider requires credentials, the workflow reports that limitation. Pull requests never authenticate to GCP or apply changes.
- `.github/workflows/terraform-deploy.yml` runs on pushes to `main` that change `terraform/**`, or by manual `workflow_dispatch`. It deploys only `terraform/environments/dev`: authenticates with WIF, checks the GCS backend bucket, initializes remote state, validates, and prints the plan.
- `.github/workflows/terraform-destroy.yml` is manual-only and targets dev. It defaults to a destroy plan without applying; actual destruction requires the `destroy` input and the exact `destroy-dev` confirmation.
- `.github/workflows/terraform-bootstrap.yml` is manual-only. Because the state bucket already exists and `terraform/bootstrap` was empty, this workflow uses a read-only Terraform data source to verify the bucket. It does not create a bucket or other infrastructure.

## Authentication and repository settings

Create these **repository variables** (not secrets):

- `WIF_PROVIDER`: the Workload Identity Provider resource name.
- `GCP_SERVICE_ACCOUNT`: the service account email to impersonate.

The deploy, bootstrap, and destroy workflows use `google-github-actions/auth@v3` with GitHub's OIDC token. No service-account key is stored in the repository. The WIF provider is restricted to repository ID `1465666026` and `refs/heads/main`; these three workflows enforce that branch before authenticating. PR validation and manual preflight have only `contents: read` permission and do not request an OIDC token.

The service account must already have the required permissions; workflows do not grant IAM roles. At minimum, it needs bucket-scoped GCS metadata access (`storage.buckets.get`, for example via `roles/storage.legacyBucketReader`), state/lock object access (for example `roles/storage.objectAdmin`), and the permissions required to create the dev VPC, subnet, GKE cluster/node pool, and enable the required Google APIs. Use narrowly scoped roles and grant bucket access on the state bucket rather than project-wide Owner access.

## State backend and bootstrap

The dev backend is configured in `terraform/environments/dev/backend.hcl`:

- Bucket: `terraform-state-bucket-hcl`
- Prefix: `terraform/state/dev`

The dev root declares the GCS backend and initializes it with this file. The deploy workflow checks that the bucket is reachable before `terraform init`; if it is missing or inaccessible, deployment stops and reports that bootstrap/bucket access must be resolved. The bucket name was supplied as an existing bucket; the bootstrap Terraform configuration only reads it. It does not create, import, or modify it.

Run **Terraform bootstrap verification** manually from the `main` branch. Leave `apply` unchecked for a plan-only verification. Enabling `apply` runs Terraform apply for a read-only data-source plan; it still creates no infrastructure.

If a local Terraform state already exists for dev, back it up securely and migrate it before using the remote backend. From `terraform/environments/dev`, run:

```shell
terraform init -migrate-state -backend-config=backend.hcl
```

Review Terraform's migration prompt and confirm the destination. Do not commit local state files. The GitHub deploy runner initializes directly against the remote backend and does not perform an automatic state migration.

## Normal dev deployments

1. Open a pull request targeting `main`; the PR workflow validates Terraform without GCP credentials.
2. Merge the reviewed change. A push to `main` runs a remote-state plan and displays it in the workflow logs; it does not apply.
3. To apply, manually run **Terraform dev deployment** from `main` with `apply` selected. The workflow applies the exact plan displayed in that run. Never dispatch it from a pull-request branch.

The deploy workflow serializes dev runs to avoid concurrent state operations. Terraform's GCS backend locking remains enabled. Plan files stay on the ephemeral runner and are removed after the job; they are not uploaded as artifacts.

## Destroying dev infrastructure

Run **Terraform dev destroy** manually from `main`. With `destroy` left unchecked, it creates and displays a destroy plan only. To execute destruction, run it with `destroy` enabled and enter `destroy-dev` exactly. Before applying the saved destroy plan, the workflow pulls the current state to a temporary runner file and copies it to `terraform/state-backups/dev/<run-id>-<attempt>.tfstate` in the same private GCS bucket. The temporary file is deleted after upload; state contents are not printed or uploaded as a GitHub artifact.

The destroy workflow shares the `terraform-dev` concurrency group with deployment, so they cannot operate on dev simultaneously. It has no push trigger and never destroys the state bucket. State backups contain sensitive infrastructure data; restrict bucket access and retain or remove backups according to your recovery policy. GCS access must be fixed for the GitHub service account before either workflow can operate.

## Manual pre-merge preflight

Run **Terraform manual preflight** from the GitHub Actions tab and select the feature branch you intend to merge. Choose `all` to validate the configured dev and bootstrap roots, or select one root; formatting is checked across all Terraform files in every scope. The optional dev plan runs without GCP credentials and reports when provider authentication prevents planning. Empty stage/prod roots are reported as skipped.

This workflow never authenticates to GCP, accesses the remote backend, or applies changes. It is suitable for pre-merge syntax and validation checks, but cannot verify WIF, IAM permissions, remote state access, or a GCP-backed plan.

## Adding stage and prod later

Before deploying either environment, populate its Terraform root, provider/backend configuration, variables, outputs, and lock file, and decide its state bucket prefix and approval policy. Then extend the deploy workflow with explicit stage/prod jobs or a controlled environment matrix, unique concurrency groups and GitHub Environments with required reviewers. Keep PR validation unauthenticated and scope any new WIF conditions and service-account access to the intended repository, branch, environment, and resources. 