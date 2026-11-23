data "google_storage_bucket" "terraform_state" {
  name = var.state_bucket_name
} 