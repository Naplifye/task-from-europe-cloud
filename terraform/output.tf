output "static_ip_mongodb" {
  description = "Public IP addresse for MongoDB instance"
  value = {
    mongodb  = google_compute_address.static_ip_mongodb.address
  }
}

output "cluster_name" {
  description = "Cluster name"
  value       = google_container_cluster.primary.name
}

output "static_ip_gke" {
  description = "Cluster static ip"
  value       = {
    gke       = module.address.addresses
  }
}