
output "network_name" {
  description = "VPC network name"
  value       = google_compute_network.vpc.name
}

output "network_id" {
  description = "VPC network ID"
  value       = google_compute_network.vpc.id
}

output "network_self_link" {
  description = "VPC self link"
  value       = google_compute_network.vpc.self_link
}

output "subnet_name" {
  description = "Name of the created subnet."
  value       = google_compute_subnetwork.this.name
}

output "subnet_id" {
  description = "ID of the created subnet."
  value       = google_compute_subnetwork.this.id
}

output "pods_secondary_range_name" {
  description = "Name of the subnet secondary range for GKE Pods."
  value       = var.pods_secondary_range_name
}

output "services_secondary_range_name" {
  description = "Name of the subnet secondary range for GKE Services."
  value       = var.services_secondary_range_name
}
 