module "ecommerce_network" {
  source = "./modules/networking"

  network_name = "ecommerce-network"
  subnetworks = [
    {
      subnetwork_name = "webapp-prod"
      ip_cidr_range   = "10.0.1.0/24"
      region          = "europe-west1"
    },
    {
      subnetwork_name = "database-prod"
      ip_cidr_range   = "10.0.2.0/24"
      region          = "europe-west1"
    },
    {
      subnetwork_name = "database-standby-prod"
      ip_cidr_range   = "10.0.3.0/24"
      region          = "europe-west1"
    },
  ]

  firewall_rules = [
    {
      firewall_rule_name = "icmp-allow"
      ranges             = ["0.0.0.0/0"]
      target_tags        = ["web-servers"]
      source_tags        = []
      
      allow = [{
        protocol = "icmp"
      }]
    }
  ]
}

module "web_servers_instance_group" {
  source = "./modules/instances"

  depends_on = [module.ecommerce_network]

  instance_template_name = "web-servers-ins-tem"
  machine_type           = "e2-medium"
  source_image           = "debian-cloud/debian-11"
  network                = "ecommerce-network"
  subnetwork             = "webapp-prod"

  health_check_name   = "web-servers-health-check"
  check_interval_sec  = 5
  timeout_sec         = 2
  healthy_threshold   = 2
  unhealthy_threshold = 10
  request_path        = "/"
  port                = "80"

  autoscaler_name        = "web-server-autoscaler"
  autoscaler_region        = "europe-west1"
  max_replicas           = 5
  min_replicas           = 1
  cooldown_period        = 300
  target_cpu_utilization = 0.6

  instance_group_name        = "web-servers-ins-group"
  base_instance_name         = "web-server"
  main_instance_group_region = "europe-west1"
  distribution_policy_zones  = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
  initial_delay_sec          = 300
}

/*module "external_load_balancer" {
  source = "GoogleCloudPlatform/lb-http/google"
  version = "~> 9.0"

  name = "web-servers-external-load-balancer"
  project = var.gcp_project

  target_tags = [ module.web_servers_instance_group.instance_group_name ]

  backends = {
    default = {
      port = 80
      protocol = "HTTP"
      port_name = "http"
      timeout_sec = 30
      enable_cdn = false
    }
  }

  health_check = {
    check_interval_sec  = 5
    timeout_sec         = 2
    healthy_threshold   = 2
    unhealthy_threshold = 10
    request_path        = "/"
    port                = 80
  }

  groups = [

  ]
}*/