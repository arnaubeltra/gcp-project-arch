module "ecommerce_network" {
  source = "./modules/networking"

  network_name = "ecommerce-network"
  subnetworks = [
    {
      subnetwork_name = "ecommerce-frontend"
      ip_cidr_range   = "10.0.1.0/24"
      region          = "europe-west1"
    },
    {
      subnetwork_name = "ecommerce-backend"
      ip_cidr_range   = "10.0.2.0/24"
      region          = "europe-west1"
    }
  ]

  firewall_rules = [
    {
      firewall_rule_name = "ecommerce-icmp-allow"
      ranges             = ["0.0.0.0/0"]
      target_tags        = ["ecommerce-servers"]
      source_tags        = []

      allow = [{
        protocol = "icmp"
      }]
    },
    {
      firewall_rule_name = "ecommerce-http-allow"
      ranges             = ["0.0.0.0/0"]
      target_tags        = ["ecommerce-frontend-servers"]
      source_tags        = []

      allow = [{
        protocol = "tcp"
        ports    = ["80"]
      }]
    },
    {
      firewall_rule_name = "ecommerce-python-server-allow"
      ranges             = ["0.0.0.0/0"] #["10.0.1.0/24",  "35.191.0.0/16", "130.211.0.0/22"]
      target_tags        = ["ecommerce-backend-servers"]
      source_tags        = []

      allow = [{
        protocol = "tcp"
        ports    = ["8000"]
      }]
    }
  ]
}

module "ecommerce_frontend_instances" {
  source = "./modules/instances"

  depends_on = [module.ecommerce_network]

  instance_template_name  = "ecommerce-frontend-instance-template"
  network_tags            = ["ecommerce-servers", "ecommerce-frontend-servers"]
  machine_type            = "e2-medium"
  source_image            = "debian-cloud/debian-11"
  network                 = "ecommerce-network"
  subnetwork              = "ecommerce-frontend"
  metadata_startup_script = <<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    EOT

  health_check_name   = "ecommerce-frontend-health-check"
  check_interval_sec  = 5
  timeout_sec         = 2
  healthy_threshold   = 2
  unhealthy_threshold = 10
  request_path        = "/"
  port                = "80"

  autoscaler_name        = "ecommerce-frontend-autoscaler"
  autoscaler_region      = "europe-west1"
  max_replicas           = 5
  min_replicas           = 1
  cooldown_period        = 300
  target_cpu_utilization = 0.6

  instance_group_name        = "ecommerce-frontend-instance-group"
  base_instance_name         = "ecommerce-frontend-instance"
  main_instance_group_region = "europe-west1"
  distribution_policy_zones  = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
  initial_delay_sec          = 300
}

module "ecommerce_backend_instances" {
  source = "./modules/instances"

  depends_on = [module.ecommerce_network]

  instance_template_name  = "ecommerce-backend-instance-template"
  network_tags            = ["ecommerce-servers", "ecommerce-backend-servers"]
  machine_type            = "e2-medium"
  source_image            = "debian-cloud/debian-11"
  network                 = "ecommerce-network"
  subnetwork              = "ecommerce-backend"
  metadata_startup_script = <<-EOT
    #!/bin/bash
    python3 -m http.server 8000
    EOT

  health_check_name   = "ecommerce-backend-health-check"
  check_interval_sec  = 5
  timeout_sec         = 2
  healthy_threshold   = 2
  unhealthy_threshold = 10
  request_path        = "/"
  port                = "8000"

  autoscaler_name        = "ecommerce-backend-autoscaler"
  autoscaler_region      = "europe-west1"
  max_replicas           = 5
  min_replicas           = 1
  cooldown_period        = 300
  target_cpu_utilization = 0.6

  instance_group_name        = "ecommerce-backend-instance-group"
  base_instance_name         = "ecommerce-backend-instance"
  main_instance_group_region = "europe-west1"
  distribution_policy_zones  = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
  initial_delay_sec          = 300
}

/*module "ecommerce_database" {
  source = "./modules/databases"

  private_ip_address_name = "database-private-ip"
  prefix_length           = 24
  network                 = "projects/my-project/global/networks/ecommerce-network"

  database_name     = "ecommerce-database"
  database_version  = "MYSQL_8_0"
  database_region   = "europe-west1"
  database_tier     = "db-f1-micro"
  availability_type = "REGIONAL"
  disk_size         = "100"

  database_read_replica_name = "ecommerce-database-read-replica"
  read_replica_region        = "europe-west2"
}*/

module "external_load_balancer" {
  source = "./modules/external-load-balancer"

  lb_forwarding_rule_name = "ecommerce-external-lb-forwarding-rule"
  region                  = "europe-west1"
  ip_protocol             = "TCP"
  load_balancing_scheme   = "EXTERNAL"
  port_range              = "80"

  lb_backend_name = "ecommerce-external-lb-backend"
  protocol        = "TCP"
  group           = module.ecommerce_frontend_instances.managed_instance_group
  balancing_mode  = "CONNECTION"

  lb_health_check_name = "ecommerce-external-lb-health-check"
  check_interval_sec   = 1
  timeout_sec          = 1
  port                 = 80
}

module "internal_load_balancer" {
  source = "./modules/internal-load-balancer"

  lb_forwarding_rule_name               = "ecommerce-internal-lb-forwarding-rule"
  region                                = "europe-west1"
  ip_protocol                           = "TCP"
  forwarding_rule_load_balancing_scheme = "INTERNAL_MANAGED"
  port_range                            = "8000"

  lb_region_target_http_proxy_name = "ecommerce-internal-lb-region-target-http-proxy"

  lb_region_url_map_name = "ecommerce-internal-lb-region-url-map"

  lb_backend_name               = "ecommerce-internal-lb-backend"
  protocol                      = "HTTP"
  backend_load_balancing_scheme = "INTERNAL_MANAGED"
  group                         = module.ecommerce_backend_instances.managed_instance_group
  balancing_mode                = "UTILIZATION"
  capacity_scaler               = 1.0

  lb_health_check_name = "ecommerce-internal-lb-health-check"
  check_interval_sec   = 1
  port                 = 8000
}