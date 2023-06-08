variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "gcp_project" {
  default = ""
}


variable "lb_forwarding_rule_name" {}

variable "ip_protocol" {}

variable "forwarding_rule_load_balancing_scheme" {}

variable "port_range" {}


variable "lb_region_target_http_proxy_name" {}


variable "lb_region_url_map_name" {}


variable "lb_backend_name" {}

variable "protocol" {}

variable "backend_load_balancing_scheme" {}

variable "group" {}

variable "balancing_mode" {}

variable "capacity_scaler" {}


variable "lb_health_check_name" {}

variable "check_interval_sec" {}

variable "timeout_sec" {}

variable "port" {}
