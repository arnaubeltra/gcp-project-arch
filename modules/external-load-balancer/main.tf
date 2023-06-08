resource "google_compute_forwarding_rule" "lb_forwarding_rule" {
  name                  = var.external_lb_forwarding_rule_name
  region                = var.region
  ip_protocol           = var.external_lb_ip_protocol
  load_balancing_scheme = var.external_lb_load_balancing_scheme
  port_range            = var.external_lb_port_range
  //network               = var.network
  //subnetwork            = var.subnetwork
  backend_service = google_compute_region_backend_service.lb_backend.id
}

resource "google_compute_region_backend_service" "lb_backend" {
  name                  = var.external_lb_backend_name
  region                = var.region
  load_balancing_scheme = var.external_lb_load_balancing_scheme
  health_checks         = [google_compute_region_health_check.lb_health_check.id]
  protocol              = var.external_lb_protocol
  backend {
    group          = var.group
    balancing_mode = var.external_lb_balancing_mode
  }
}

resource "google_compute_region_health_check" "lb_health_check" {
  name               = var.external_lb_health_check_name
  region             = var.region
  check_interval_sec = var.external_lb_check_interval_sec
  timeout_sec        = var.external_lb_timeout_sec

  http_health_check {
    port = var.external_lb_port
  }
}