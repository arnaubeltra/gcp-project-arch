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
  default = []
  type = list(object({
    firewall_rule_name  = string
    ranges = list(string)
    target_tags = list(string)

    allow = list(object({
      protocol = string
      ports = optional(list(string)) 
    }))
  }))
}
