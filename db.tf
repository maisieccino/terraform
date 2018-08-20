resource "google_sql_database_instance" "db_instance" {
  name = "main-instance"

  settings {
    tier = "db-f1-micro"
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
