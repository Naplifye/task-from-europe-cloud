resource "google_container_cluster" "primary" {
  name                        = "${var.cluster_name}-${var.env_name}"
  location                    = var.zone
  network                     = google_compute_network.custom.name
  subnetwork                  = google_compute_subnetwork.custom.name
  initial_node_count          = 2
  deletion_protection         = false
    
    ip_allocation_policy {
    services_secondary_range_name = google_compute_subnetwork.custom.secondary_ip_range.0.range_name
    cluster_secondary_range_name  = google_compute_subnetwork.custom.secondary_ip_range.1.range_name
    }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "nodeapp-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  
  autoscaling {
    min_node_count = 2
    max_node_count = 8
  }

  node_config {
    preemptible               = true
    machine_type              = var.machine_type
    disk_size_gb              = 30
    disk_type                 = "pd-standard"
    tags                      = ["allow-ports"]
  }
}