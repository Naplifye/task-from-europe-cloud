data "google_client_openid_userinfo" "me" {}

resource "google_compute_instance" "mongodb" {
  project      = var.project_id
  name         = "mongodb"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["allow-ports"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 30
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = google_compute_network.custom.name
    access_config {
      nat_ip = google_compute_address.static_ip_mongodb.address
    }
    subnetwork = google_compute_subnetwork.custom.name
  }

  metadata = {
    ssh-keys = "${split("@", data.google_client_openid_userinfo.me.email)[0]}:${tls_private_key.ssh.public_key_openssh}"
  }
}
