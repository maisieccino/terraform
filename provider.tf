provider "google" {
  region      = "${var.google_region}"
  project     = "${var.google_project_name}"
  credentials = "${file(var.google_key_path)}"
  version     = "~> 1.16"
}
