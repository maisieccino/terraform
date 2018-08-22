resource "google_sql_database_instance" "db_instance" {
  name             = "main-db-instance"
  database_version = "POSTGRES_9_6"
  project          = "${var.google_project_name}"
  region           = "${var.google_region}"

  settings {
    tier        = "db-f1-micro"
    require_ssl = true
  }
}

resource "google_sql_user" "db_user" {
  name     = "${var.db_user}"
  instance = "${google_sql_database_instance.db_instance.name}"
  password = "${var.db_pass}"
}

resource "google_sql_database" "concourse_db" {
  name     = "concourse-db"
  instance = "${google_sql_database_instance.db_instance.name}"
}
