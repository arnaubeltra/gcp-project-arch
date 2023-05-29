resource "google_compute_network" "vpc_network" {
  name = var.network_name
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
  mtu = 1460
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name = var.subnetwork_name
  ip_cidr_range = var.ip_cidr_range
  region = var.region
  network = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "vpc_firewall_rule" {
  name = var.firewall_rule_name
  network = google_compute_network.vpc_network.id

  allow {
    protocol = var.protocol
    ports = var.ports
  }

  source_tags = var.source_tags
}