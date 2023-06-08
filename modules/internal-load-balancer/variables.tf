variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "gcp_project" {
  default = ""
}


variable "internal_lb_network" {}

variable "internal_lb_subnetwork" {}


variable "internal_lb_forwarding_rule_name" {}

variable "internal_lb_ip_protocol" {}

variable "internal_lb_load_balancing_scheme" {}

variable "internal_lb_port_range" {}


variable "lb_region_target_http_proxy_name" {}


variable "lb_region_url_map_name" {}


variable "internal_lb_backend_name" {}

variable "internal_lb_protocol" {}

variable "backend_load_balancing_scheme" {}

variable "group" {}

variable "internal_lb_balancing_mode" {}

variable "capacity_scaler" {}


variable "internal_lb_health_check_name" {}

variable "internal_lb_check_interval_sec" {}

variable "internal_lb_timeout_sec" {}

variable "internal_lb_port" {}
