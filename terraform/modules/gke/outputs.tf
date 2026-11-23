output "cluster_name" {
  description = "Name of the GKE cluster."
  value       = google_container_cluster.this.name
}

output "cluster_location" {
  description = "Zone where the zonal GKE cluster runs."
  value       = google_container_cluster.this.location
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint for the cluster."
  value       = google_container_cluster.this.endpoint
}

output "node_pool_name" {
  description = "Name of the cluster's worker node pool."
  value       = google_container_node_pool.primary.name
} 