variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "gcp_project" {
  default = "spa-learningdev-dev-001"
}


variable "network_name" {}


variable "subnetworks" {
  type = list(map(string))
}


variable "firewall_rules" {
  type = list(map(string))
}
