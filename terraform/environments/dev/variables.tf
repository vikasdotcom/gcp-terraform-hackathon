variable "project_id" {
  description = "Google Cloud project ID with billing enabled."
  type        = string
}

variable "region" {
  description = "Region for the VPC subnet."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Single zone for the low-cost GKE cluster."
  type        = string
  default     = "us-central1-a"
} 