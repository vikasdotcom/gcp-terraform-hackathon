output "network_name" {
  description = "Name of the dev VPC network."
  value       = module.network.network_name
}

output "subnet_name" {
  description = "Name of the dev GKE subnet."
  value       = module.network.subnet_name
}

output "gke_cluster_name" {
  description = "Name of the dev GKE cluster."
  value       = module.gke.cluster_name
}

output "gke_cluster_location" {
  description = "Zone of the dev GKE cluster."
  value       = module.gke.cluster_location
}

output "gke_cluster_endpoint" {
  description = "Kubernetes API endpoint for the dev cluster."
  value       = module.gke.cluster_endpoint
} 