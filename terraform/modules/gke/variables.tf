variable "cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
}

variable "location" {
  description = "A single zone for a lower-cost zonal cluster, for example us-central1-a."
  type        = string
}

variable "network" {
  description = "VPC network name or self link."
  type        = string
}

variable "subnetwork" {
  description = "Subnet name or self link for the cluster."
  type        = string
}

variable "pods_secondary_range_name" {
  description = "Subnet secondary range name for GKE Pods."
  type        = string
}

variable "services_secondary_range_name" {
  description = "Subnet secondary range name for GKE Services."
  type        = string
}

variable "node_count" {
  description = "Fixed number of small worker nodes."
  type        = number
  default     = 1

  validation {
    condition     = var.node_count >= 1
    error_message = "node_count must be at least 1."
  }
}

variable "machine_type" {
  description = "Compute Engine machine type for each worker node."
  type        = string
  default     = "e2-small"
}

variable "node_disk_size_gb" {
  description = "Standard persistent disk size per worker node in GB."
  type        = number
  default     = 20
} 