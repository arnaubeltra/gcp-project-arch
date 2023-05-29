
module "ecommerce_network" {
  source = "./modules/networking"

  network_name = "ecommerce_network"
  subnetworks = [ 
    {
        subnetwork_name = "webapp_prod_1"
        ip_cidr_range = "10.0.1.0/24"
        region = "europe-west1-b"
    },
    {
        subnetwork_name = "webapp_prod_2"
        ip_cidr_range = "10.0.2.0/24"
        region = "europe-west1-c"
    },
    {
        subnetwork_name = "webapp_prod_3"
        ip_cidr_range = "10.0.3.0/24"
        region = "europe-west1-d"
    },
    {
        subnetwork_name = "database_prod"
        ip_cidr_range = "10.0.4.0/24"
        region = "europe-west1-b"
    },
    {
        subnetwork_name = "database_standby_prod"
        ip_cidr_range = "10.0.5.0/24"
        region = "europe-west1-c"
    },
   ]

  firewall_rules = [
    {
        firewall_rule_name = "icmp-allow"
        protocol = "icmp"
        ports = null
        source_tags = ["web_servers"]
    }
  ]
}

module "web_servers_instance_group" {
  source = "./modules/instances"

  instance_template_name = "web_servers_ins_tem"
  machine_type = "e2-medium"
  source_image = "debian-cloud/debian-11"
  network = module.ecommerce_network.network_name
  subnetwork = "webapp_prod_1"

  health_check_name = "web_servers_health_check"
  check_interval_sec = 5
  timeout_sec = 2
  healthy_threshold = 2
  unhealthy_threshold = 10
  request_path = "/"
  port = "80"

  autoscaler_name = "web_server_autoscaler"
  autoscaler_zone = "europe-west1-b"
  max_replicas = 5
  min_replicas = 1
  cooldown_period = 300
  target_cpu_utilization = 0.6

  instance_group_name = "web_servers_ins_group"
  base_instance_name = "web_server"
  main_instance_group_zone = "europe-west1-b"
  distribution_policy_zones = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
  initial_delay_sec = 300
}

/*module "load_balancer_http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "~> 6.0"
  name    = "ecommerce_load_balancer"
  project = var.project
}*/