resource "google_compute_instance" "concourse_instance" {
  name         = "concourse-instance"
  zone         = "${var.concourse_instance_zone}"
  machine_type = "${var.concourse_instance_type}"
  tags         = ["web", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  connection {
    type        = "ssh"
    user        = "${var.concourse_user}"
    private_key = "${file(var.concourse_ssh_priv_key)}"
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

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/ubuntu/.postgresql",
    ]
  }

  provisioner "local-exec" {
    command = "ssh-keyscan -H ${google_compute_instance.concourse_instance.network_interface.0.access_config.0.assigned_nat_ip} >> ~/.ssh/known_hosts"
  }

  provisioner "file" {
    content     = "${local.db_cacert}"
    destination = "/home/ubuntu/.postgresql/root.crt"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu --private-key ${var.concourse_ssh_priv_key} -i '${local.concourse_ip},' -e 'ansible_python_interpreter=\"/usr/bin/python3\"' concourse.yml"

    environment {
      PG_CONNSTRING = "${local.concourse_db_connstring}"
      PG_USER       = "${var.db_user}"
      PG_PASS       = "${var.db_pass}"
      PG_HOST       = "${local.db_host}"
      PG_DBNAME     = "${var.concourse_dbname}"
    }
  }

  depends_on = ["google_sql_database_instance.db_instance"]
}
