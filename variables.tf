variable "google_region" {
  default     = "europe-west1"
  description = "The region in which to deploy to"
}

variable "google_project_name" {
  default     = "mbell-me"
  description = "The name of your Google Cloud project"
}

variable "google_key_path" {
  default     = "~/terraform.json"
  description = "The path to the JSON key used to access your Google Cloud service account."
}

variable "concourse_instance_zone" {
  default     = "europe-west1-b"
  description = "The availability zone in which Concourse will run."
}

variable "concourse_instance_type" {
  default     = "f1-micro"
  description = "The machine type that Concourse will use"
}

variable "concourse_user" {
  default = "concourse"
}

variable "concourse_ssh_pub_key" {
  default = "./key.pub"
}

variable "db_user" {
  default     = "dbuser"
  description = "Username for the database admin"
}

variable "db_pass" {
  default     = "somestrongpassword"
  description = "Password for the database admin"
}
