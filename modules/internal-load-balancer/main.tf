resource "google_compute_forwarding_rule" "lb_forwarding_rule" {
  name                  = var.lb_forwarding_rule_name
  region                = var.region
  ip_protocol           = var.ip_protocol
  load_balancing_scheme = var.forwarding_rule_load_balancing_scheme
  port_range            = var.port_range
  target                = google_compute_region_target_http_proxy.lb_region_target_http_proxy.id
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
  name                  = var.lb_backend_name
  region                = var.region
  protocol              = var.protocol
  load_balancing_scheme = var.backend_load_balancing_scheme

  health_checks = [google_compute_region_health_check.lb_health_check.id]
  backend {
    group           = var.group
    balancing_mode  = var.balancing_mode
    capacity_scaler = var.capacity_scaler
  }
}

resource "google_compute_region_health_check" "lb_health_check" {
  name               = var.lb_health_check_name
  region             = var.region
  check_interval_sec = var.check_interval_sec

  http_health_check {
    port = var.port
  }
}