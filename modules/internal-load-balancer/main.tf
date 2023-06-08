resource "google_compute_subnetwork" "lb_subnetwork" {
  name          = var.internal_lb_subnet_name
  ip_cidr_range = var.subnet_ip_cidr_range
  region        = var.region
  purpose       = var.subnet_purpose
  role          = var.subnet_role
  network       = var.internal_lb_network
}

resource "google_compute_forwarding_rule" "lb_forwarding_rule" {
  name                  = var.internal_lb_forwarding_rule_name
  region                = var.region
  depends_on            = [google_compute_subnetwork.lb_subnetwork]
  ip_protocol           = var.internal_lb_ip_protocol
  load_balancing_scheme = var.internal_lb_load_balancing_scheme
  port_range            = var.internal_lb_port_range
  target                = google_compute_region_target_http_proxy.lb_region_target_http_proxy.id
  network               = var.internal_lb_network
  subnetwork            = var.internal_lb_subnetwork
  network_tier          = var.network_tier
}

resource "google_compute_region_target_http_proxy" "lb_region_target_http_proxy" {
  name    = var.lb_region_target_http_proxy_name
  region  = var.region
  url_map = google_compute_region_url_map.lb_region_url_map.id
}

resource "google_compute_region_url_map" "lb_region_url_map" {
  name            = var.lb_region_url_map_name
  region          = var.region
  default_service = google_compute_region_backend_service.lb_backend_service.id
}

resource "google_compute_region_backend_service" "lb_backend_service" {
  name                  = var.internal_lb_backend_name
  region                = var.region
  protocol              = var.internal_lb_protocol
  load_balancing_scheme = var.backend_load_balancing_scheme
  port_name             = var.port_name

  health_checks = [google_compute_region_health_check.lb_health_check.id]
  backend {
    group           = var.group
    balancing_mode  = var.internal_lb_balancing_mode
    capacity_scaler = var.capacity_scaler
  }
}

resource "google_compute_region_health_check" "lb_health_check" {
  name               = var.internal_lb_health_check_name
  region             = var.region
  check_interval_sec = var.internal_lb_check_interval_sec
  timeout_sec        = var.internal_lb_timeout_sec

  http_health_check {
    port = var.internal_lb_port
  }
}
