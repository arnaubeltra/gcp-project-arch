variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "gcp_project" {
  default = ""
}


variable "external_lb_forwarding_rule_name" {}

variable "external_lb_ip_protocol" {}

variable "external_lb_load_balancing_scheme" {}

variable "external_lb_port_range" {}

/*variable "network" {}

variable "subnetwork" {}*/


variable "external_lb_backend_name" {}

variable "external_lb_protocol" {}

variable "group" {}

variable "external_lb_balancing_mode" {}


variable "external_lb_health_check_name" {}

variable "external_lb_check_interval_sec" {}

variable "external_lb_timeout_sec" {}

variable "external_lb_port" {}