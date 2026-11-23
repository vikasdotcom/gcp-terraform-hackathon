variable "project_id" {
  description = "Google Cloud project that contains the existing Terraform state bucket."
  type        = string
}

variable "state_bucket_name" {
  description = "Name of the existing GCS bucket used for Terraform state."
  type        = string
} 