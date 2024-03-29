variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "gcp_project" {
  default = ""
}


variable "private_ip_address_name" {}

variable "prefix_length" {}

variable "database_network" {}


variable "database_name" {}

variable "database_version" {}

variable "database_region" {}

variable "database_tier" {}

variable "availability_type" {}

variable "disk_size" {}


variable "database_read_replica_name" {}

variable "read_replica_region" {}