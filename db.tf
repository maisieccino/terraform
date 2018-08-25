resource "google_sql_database_instance" "db_instance" {
  name             = "main-db-instance"
  database_version = "POSTGRES_9_6"
  project          = "${var.google_project_name}"
  region           = "${var.google_region}"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      require_ssl = false

      authorized_networks = [
        {
          name  = "concourse-instance"
          value = "${local.concourse_ip}"
        },
      ]
    }
  }
}

locals {
  db_host   = "${google_sql_database_instance.db_instance.first_ip_address}"
  db_cacert = "${google_sql_database_instance.db_instance.server_ca_cert.0.cert}"
}

locals {
  concourse_db_connstring = "postgresql://${var.db_user}:${var.db_pass}@${local.db_host}/${var.concourse_dbname}?sslmode=verify-full"
}

output "concourse_db_connstring" {
  value     = "${local.concourse_db_connstring}"
  sensitive = true
}

output "db_pass" {
  value     = "${var.db_pass}"
  sensitive = true
}

output "db_host" {
  value     = "${local.db_host}"
  sensitive = true
}

resource "google_sql_user" "db_user" {
  name     = "${var.db_user}"
  instance = "${google_sql_database_instance.db_instance.name}"
  password = "${var.db_pass}"
}

resource "google_sql_database" "concourse_db" {
  name     = "${var.concourse_dbname}"
  instance = "${google_sql_database_instance.db_instance.name}"
}
