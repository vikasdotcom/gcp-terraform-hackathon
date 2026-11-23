# Terraform state management

Dev uses the existing GCS bucket `terraform-state-bucket-hcl`, with the `terraform/state/dev` prefix. The GCS backend provides remote state and locking; the deploy workflow checks bucket access before initialization and stops if the bucket is missing or inaccessible.

The bucket was supplied as already created. `terraform/bootstrap` only verifies it with a read-only data source and uses local state; it does not create or manage the bucket. The bucket itself should have suitable access controls and object versioning configured by its owner. Do not store Terraform state or plan files in the repository.

If a local state file exists before enabling the backend, back it up securely and migrate it with:

```shell
terraform init -migrate-state -backend-config=backend.hcl
```

Run this from `terraform/environments/dev`, review the prompt, and confirm the remote destination. The deployment workflow does not migrate state automatically. Bootstrap state is local and contains only the read-only bucket verification. 