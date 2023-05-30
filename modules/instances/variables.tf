variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}

variable "gcp_project" {
  default = "spa-learningdev-dev-001"
}


variable "instance_template_name" {}

variable "machine_type" {
  default = "e2-medium"
}

variable "source_image" {
  default = "debian-cloud/debian-11"
}


variable "network" {}

variable "subnetwork" {}


variable "health_check_name" {}

variable "check_interval_sec" {
  default = 5
}

variable "timeout_sec" {
  default = 2
}

variable "healthy_threshold" {
  default = 2
}

variable "unhealthy_threshold" {
  default = 10
}

variable "request_path" {}

variable "port" {}


variable "autoscaler_name" {}

variable "autoscaler_zone" {}

variable "max_replicas" {}

variable "min_replicas" {
  default = 1
}

variable "cooldown_period" {}

variable "target_cpu_utilization" {}


variable "instance_group_name" {}

variable "base_instance_name" {}

variable "main_instance_group_region" {}

variable "distribution_policy_zones" {
  type = list(string)
}

variable "initial_delay_sec" {}