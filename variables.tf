variable "region" {
  description = "The region where the resources will be created."
  default     = "europe-west1"
}

variable "zone" {
  description = "The specific zone within the region where the resources will be created."
  default     = "europe-west1-b"
}

variable "gcp_project" {
  description = "The name or ID of the Google Cloud Platform project."
  default     = ""
}


# Networking module
variable "network_name" {
  description = "The name of the network."
  type        = string
}

variable "subnetworks" {
  description = "A list of subnetwork configurations."
  type        = list(map(string))
}

variable "firewall_rules" {
  description = "A list of firewall rule configurations."
  default     = []
  type = list(object({
    firewall_rule_name = string
    ranges             = list(string)
    target_tags        = optional(list(string))
    source_tags        = optional(list(string))

    allow = list(object({
      protocol = string
      ports    = optional(list(string))
    }))
  }))
}


# Instances module
variable "instances" {
  description = "Map of objects representing the instances configuration"
  type = map(object({
    network_tags                 = list(string)
    machine_type                 = string
    source_image                 = string
    instances_network            = string
    instances_subnetwork         = string
    metadata_startup_script      = string
    health_check_name            = string
    instances_check_interval_sec = number
    instances_timeout_sec        = number
    healthy_threshold            = number
    unhealthy_threshold          = number
    request_path                 = string
    instances_port               = number
    autoscaler_name              = string
    autoscaler_region            = string
    max_replicas                 = number
    min_replicas                 = number
    cooldown_period              = number
    target_cpu_utilization       = number
    instance_group_name          = string
    base_instance_name           = string
    main_instance_group_region   = string
    distribution_policy_zones    = list(string)
    initial_delay_sec            = number
  }))
}



# Databases module
/*variable "private_ip_address_name" {
  description = "Name for the private IP address"
  type        = string
}

variable "prefix_length" {
  description = "Prefix length for the private IP address"
  type        = number
}

variable "network" {
  description = "Network for the database"
  type        = string
}

variable "database_name" {
  description = "Name of the database"
  type        = string
}

variable "database_version" {
  description = "Version of the database"
  type        = string
}

variable "database_region" {
  description = "Region for the database"
  type        = string
}

variable "database_tier" {
  description = "Database tier"
  type        = string
}

variable "availability_type" {
  description = "Availability type for the database"
  type        = string
}

variable "disk_size" {
  description = "Disk size for the database"
  type        = string
}

variable "database_read_replica_name" {
  description = "Name of the database read replica"
  type        = string
}

variable "read_replica_region" {
  description = "Region for the database read replica"
  type        = string
}*/


# External load balancer module
variable "external_lb_forwarding_rule_name" {
  description = "Name of the external load balancer forwarding rule"
  type        = string
}

variable "external_lb_ip_protocol" {
  description = "IP protocol for the external load balancer"
  type        = string
}

variable "external_lb_load_balancing_scheme" {
  description = "Load balancing scheme for the external load balancer"
  type        = string
}

variable "external_lb_port_range" {
  description = "Port range for the external load balancer"
  type        = string
}

variable "external_lb_backend_name" {
  description = "Name of the external load balancer backend"
  type        = string
}

variable "external_lb_protocol" {
  description = "Protocol for the external load balancer"
  type        = string
}

variable "external_lb_balancing_mode" {
  description = "Balancing mode for the external load balancer"
  type        = string
}

variable "external_lb_health_check_name" {
  description = "Name of the external load balancer health check"
  type        = string
}

variable "external_lb_check_interval_sec" {
  description = "Check interval in seconds for the external load balancer"
  type        = number
}

variable "external_lb_timeout_sec" {
  description = "Timeout in seconds for the external load balancer"
  type        = number
}

variable "external_lb_port" {
  description = "Port for the external load balancer"
  type        = number
}


# Internal load balancer module 
variable "internal_lb_network" {
  description = "Name of the internal load balancer network"
  type        = string
}

variable "internal_lb_subnetwork" {
  description = "Name of the internal load balancer subnetwork"
  type        = string
}

variable "internal_lb_subnet_name" {
  description = "Name of the subnetwork"
  type        = string
}

variable "subnet_ip_cidr_range" {
  description = "IP CIDR range for the subnetwork"
  type        = string
}

variable "subnet_purpose" {
  description = "Purpose of the subnetwork"
  type        = string
}

variable "subnet_role" {
  description = "Role of the subnetwork"
  type        = string
}

variable "internal_lb_forwarding_rule_name" {
  description = "Name of the internal load balancer forwarding rule"
  type        = string
}

variable "internal_lb_ip_protocol" {
  description = "IP protocol for the internal load balancer"
  type        = string
}

variable "internal_lb_load_balancing_scheme" {
  description = "Load balancing scheme for the internal load balancer"
  type        = string
}

variable "internal_lb_port_range" {
  description = "Port range for the internal load balancer"
  type        = string
}

variable "network_tier" {
  description = "Network tier for the internal load balancer"
  type        = string
}

variable "lb_region_target_http_proxy_name" {
  description = "Name of the internal load balancer region target HTTP proxy"
  type        = string
}

variable "lb_region_url_map_name" {
  description = "Name of the internal load balancer region URL map"
  type        = string
}

variable "internal_lb_backend_name" {
  description = "Name of the internal load balancer backend"
  type        = string
}

variable "internal_lb_protocol" {
  description = "Protocol for the internal load balancer"
  type        = string
}

variable "backend_load_balancing_scheme" {
  description = "Load balancing scheme for the backend of the internal load balancer"
  type        = string
}

variable "port_name" {
  description = "Port name for the backend of the internal load balancer"
  type        = string
}

variable "internal_lb_balancing_mode" {
  description = "Balancing mode for the internal load balancer"
  type        = string
}

variable "capacity_scaler" {
  description = "Capacity scaler for the internal load balancer"
  type        = number
}

variable "internal_lb_health_check_name" {
  description = "Name of the internal load balancer health check"
  type        = string
}

variable "internal_lb_check_interval_sec" {
  description = "Check interval in seconds for the internal load balancer"
  type        = number
}

variable "internal_lb_timeout_sec" {
  description = "Timeout in seconds for the internal load balancer"
  type        = number
}

variable "internal_lb_port" {
  description = "Port for the internal load balancer"
  type        = number
}