resource "google_compute_address" "concourse_address" {
  name = "concourse-external-address"
}

locals {
  concourse_ip = "${google_compute_address.concourse_address.address}"
}

output "concourse_ip" {
  value = "${local.concourse_ip}"
}

resource "google_compute_firewall" "concourse_firewall_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_tags = ["web"]
}
