output "state_bucket_name" {
  description = "Name of the verified Terraform state bucket."
  value       = data.google_storage_bucket.terraform_state.name
}

output "state_bucket_location" {
  description = "Location of the verified Terraform state bucket."
  value       = data.google_storage_bucket.terraform_state.location
} 