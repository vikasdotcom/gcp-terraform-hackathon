# GitHub Actions authentication to Google Cloud

Deployment and bootstrap workflows use Workload Identity Federation (WIF) through `google-github-actions/auth@v3`; they do not use service-account keys. Configure the GitHub repository variables `WIF_PROVIDER` and `GCP_SERVICE_ACCOUNT` with the provider resource name and service-account email.

The provider condition is restricted to repository ID `1465666026` and the `main` branch. Deploy and bootstrap workflows check `refs/heads/main` before requesting credentials. The PR validation workflow has `contents: read` only and never authenticates to Google Cloud.

Grant the impersonated service account only the permissions it needs: bucket-scoped GCS metadata access (`storage.buckets.get`, for example via `roles/storage.legacyBucketReader`) and state/lock object access (for example `roles/storage.objectAdmin`) on the state bucket, plus the required Compute Engine, GKE, and Service Usage permissions for dev deployments. Do not grant project Owner. Workflows do not change IAM bindings. 