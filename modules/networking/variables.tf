variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "project_id" {
  default = "spa-learningdev-dev-001"
}


variable "network_name" {}


variable "subnetworks" {
  type = list(object({
    subnetwork_name   = string
    ip_cidr_range = string
    region        = string
  }))
}


variable "firewall_rules" {
  type = list(object({
    firewall_rule_name  = string
    protocol            = string
    ports               = number
    source_tags         = list(string)
  }))
}
