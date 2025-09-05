resource "google_compute_network" "custom" {
  name                    = "${var.network}-${var.env_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "custom" {
  name          = "${var.subnetwork}-${var.env_name}"
  ip_cidr_range = "10.10.0.0/16"
  region        = var.region
  network       = google_compute_network.custom.name
  
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.20.0.0/16"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "10.30.0.0/16"
  }
}

resource "google_compute_firewall" "custom" {
  name                    = "${var.subnetwork}-${var.env_name}"
  network                 = google_compute_network.custom.name
  source_ranges           = ["0.0.0.0/0"]
  target_tags             = ["allow-ports"]

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
}

resource "google_compute_address" "static_ip_mongodb" {
  project = var.project_id
  region  = var.region
  name    = "mongodb-static-ip"
}

module "address" {
  source       = "terraform-google-modules/address/google"
  project_id   = var.project_id
  region       = var.region
  address_type = "EXTERNAL"
  names        = ["gke-static-ip"]
  global       = true
}