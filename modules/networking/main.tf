resource "google_compute_network" "vpc_network" {
  name = var.network_name
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
  mtu = 1460
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  for_each = local.subnetworks

  name = each.value.subnetwork_name
  ip_cidr_range = each.value.ip_cidr_range
  region = each.value.region
  network = google_compute_network.vpc_network.id
}

/*resource "google_compute_firewall" "vpc_firewall_rule" {
  for_each = local.firewall_rules

  name = each.value
  network = google_compute_network.vpc_network.id

  allow {
    protocol = each.value.protocol
    ports = each.value.ports
  }

  source_tags = each.value.source_tags
}*/