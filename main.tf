module "ecommerce_network" {
  source         = "./modules/networking"
  network_name   = var.network_name
  subnetworks    = var.subnetworks
  firewall_rules = var.firewall_rules
}

module "ecommerce_instances" {
  source     = "./modules/instances"
  depends_on = [module.ecommerce_network]

  for_each = var.instances

  instance_template_name  = each.key
  network_tags            = each.value.network_tags
  machine_type            = each.value.machine_type
  source_image            = each.value.source_image
  instances_network       = each.value.instances_network
  instances_subnetwork    = each.value.instances_subnetwork
  metadata_startup_script = each.value.metadata_startup_script

  health_check_name            = each.value.health_check_name
  instances_check_interval_sec = each.value.instances_check_interval_sec
  instances_timeout_sec        = each.value.instances_timeout_sec
  healthy_threshold            = each.value.healthy_threshold
  unhealthy_threshold          = each.value.unhealthy_threshold
  request_path                 = each.value.request_path
  instances_port               = each.value.instances_port

  autoscaler_name        = each.value.autoscaler_name
  autoscaler_region      = each.value.autoscaler_region
  max_replicas           = each.value.max_replicas
  min_replicas           = each.value.min_replicas
  cooldown_period        = each.value.cooldown_period
  target_cpu_utilization = each.value.target_cpu_utilization

  instance_group_name        = each.value.instance_group_name
  base_instance_name         = each.value.base_instance_name
  main_instance_group_region = each.value.main_instance_group_region
  distribution_policy_zones  = each.value.distribution_policy_zones
  initial_delay_sec          = each.value.initial_delay_sec
}

/*module "ecommerce_database" {
  source = "./modules/databases"

  private_ip_address_name     = var.private_ip_address_name
  prefix_length               = var.prefix_length
  database_network                     = var.database_network
  
  database_name               = var.database_name
  database_version            = var.database_version
  database_region             = var.database_region
  database_tier               = var.database_tier
  availability_type           = var.availability_type
  disk_size                   = var.disk_size
  
  database_read_replica_name  = var.database_read_replica_name
  read_replica_region         = var.read_replica_region
}*/

module "external_load_balancer" {
  source = "./modules/external-load-balancer"

  depends_on = [module.ecommerce_instances["ecommerce-frontend-instance-template"]]

  external_lb_forwarding_rule_name  = var.external_lb_forwarding_rule_name
  region                            = var.region
  external_lb_ip_protocol           = var.external_lb_ip_protocol
  external_lb_load_balancing_scheme = var.external_lb_load_balancing_scheme
  external_lb_port_range            = var.external_lb_port_range

  external_lb_backend_name   = var.external_lb_backend_name
  external_lb_protocol       = var.external_lb_protocol
  group                      = module.ecommerce_instances["ecommerce-frontend-instance-template"].managed_instance_group
  external_lb_balancing_mode = var.external_lb_balancing_mode

  external_lb_health_check_name  = var.external_lb_health_check_name
  external_lb_check_interval_sec = var.external_lb_check_interval_sec
  external_lb_timeout_sec        = var.external_lb_timeout_sec
  external_lb_port               = var.external_lb_port
}

module "internal_load_balancer" {
  source = "./modules/internal-load-balancer"

  depends_on = [module.ecommerce_instances["ecommerce-backend-instance-template"]]

  internal_lb_network    = var.internal_lb_network
  internal_lb_subnetwork = var.internal_lb_subnetwork

  internal_lb_forwarding_rule_name  = var.internal_lb_forwarding_rule_name
  region                            = var.region
  internal_lb_ip_protocol           = var.internal_lb_ip_protocol
  internal_lb_load_balancing_scheme = var.internal_lb_load_balancing_scheme
  internal_lb_port_range            = var.internal_lb_port_range

  lb_region_target_http_proxy_name = var.lb_region_target_http_proxy_name

  lb_region_url_map_name = var.lb_region_url_map_name

  internal_lb_backend_name      = var.internal_lb_backend_name
  internal_lb_protocol          = var.internal_lb_protocol
  backend_load_balancing_scheme = var.backend_load_balancing_scheme
  group                         = module.ecommerce_instances["ecommerce-backend-instance-template"].managed_instance_group
  internal_lb_balancing_mode    = var.internal_lb_balancing_mode
  capacity_scaler               = var.capacity_scaler

  internal_lb_health_check_name  = var.internal_lb_health_check_name
  internal_lb_check_interval_sec = var.internal_lb_check_interval_sec
  internal_lb_timeout_sec        = var.internal_lb_timeout_sec
  internal_lb_port               = var.internal_lb_port
}
