resource "google_compute_network" "vpc_network" {
  name = var.network_name
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
  mtu = 1460
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  for_each = { for x in var.subnetworks : "${x.region}/${x.subnetwork_name}" => x }

  name = each.value.subnetwork_name
  ip_cidr_range = each.value.ip_cidr_range
  region = each.value.region
  network = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "vpc_firewall_rule" {
  for_each = { for r in var.firewall_rules : r.firewall_rule_name => r }

  name = each.value.firewall_rule_name
  network = google_compute_network.vpc_network.id
  target_tags = each.value.target_tags


  dynamic "allow" {
    for_each = lookup(each.value, "allow", [])
    content {
      protocol = allow.value.protocol
      ports = lookup(allow.value, "ports", null)
    }
  }
}