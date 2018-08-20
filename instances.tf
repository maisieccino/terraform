resource "google_compute_instance" "concourse_instance" {
  name         = "concourse-instance"
  zone         = "${var.concourse_instance_zone}"
  machine_type = "${var.concourse_instance_type}"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = "${google_compute_address.concourse_address.address}"
    }
  }

  metadata {
    sshKeys = "${var.concourse_user}:${file(var.concourse_ssh_pub_key)}"
  }

  depends_on = ["google_sql_database_instance.db_instance"]
}
