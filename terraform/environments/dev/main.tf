resource "google_project_service" "compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "container" {
  project            = var.project_id
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

module "network" {
  source = "../../modules/network"

  project_id   = var.project_id
  network_name = "dev-gke-vpc"
  subnet_name  = "dev-gke-subnet"
  region       = var.region

  depends_on = [google_project_service.compute]
}

module "gke" {
  source = "../../modules/gke"

  cluster_name                  = "dev-gke"
  location                      = var.zone
  network                       = module.network.network_id
  subnetwork                    = module.network.subnet_id
  pods_secondary_range_name     = module.network.pods_secondary_range_name
  services_secondary_range_name = module.network.services_secondary_range_name

  depends_on = [google_project_service.container]
} 