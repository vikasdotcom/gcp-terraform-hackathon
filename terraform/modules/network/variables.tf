
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet used by the GKE cluster."
  type        = string
}

variable "region" {
  description = "Region in which to create the subnet."
  type        = string
}

variable "subnet_cidr" {
  description = "Primary IPv4 CIDR range for the subnet."
  type        = string
  default     = "10.0.0.0/20"
}

variable "pods_secondary_cidr" {
  description = "Secondary IPv4 CIDR range allocated to GKE Pods."
  type        = string
  default     = "10.4.0.0/14"
}

variable "services_secondary_cidr" {
  description = "Secondary IPv4 CIDR range allocated to GKE Services."
  type        = string
  default     = "10.8.0.0/20"
}

variable "pods_secondary_range_name" {
  description = "Name of the subnet secondary range for GKE Pods."
  type        = string
  default     = "gke-pods"
}

variable "services_secondary_range_name" {
  description = "Name of the subnet secondary range for GKE Services."
  type        = string
  default     = "gke-services"
}

variable "routing_mode" {
  description = "VPC routing mode"
  type        = string
  default     = "REGIONAL"

  validation {
    condition = contains(
      ["REGIONAL", "GLOBAL"],
      var.routing_mode
    )
    error_message = "Routing mode must be REGIONAL or GLOBAL."
  }
}

variable "description" {
  description = "Description of the VPC"
  type        = string
  default     = "Terraform managed VPC"
}
 