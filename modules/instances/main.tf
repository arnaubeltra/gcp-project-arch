resource "google_compute_instance_template" "instance_template_app" {
  name = var.instance_template_name
  
  tags = ["web_servers"]
  machine_type = var.machine_type

  scheduling {
    automatic_restart = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = var.source_image
    auto_delete = true
    boot = true
  }

  network_interface {
    network = var.network
    subnetwork = var.subnetwork
    access_config {}
  }
}

resource "google_compute_health_check" "health_check_app" {
  name = var.health_check_name

  check_interval_sec = var.check_interval_sec
  timeout_sec = var.timeout_sec
  healthy_threshold = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  http_health_check {
    request_path = var.request_path
    port = var.port
  }
}

resource "google_compute_autoscaler" "autoscaler_app" {
  name = var.autoscaler_name

  zone = var.autoscaler_zone
  target = google_compute_region_instance_group_manager.managed_instance_group_app.id

  autoscaling_policy {
    mode = "ON"
    max_replicas = var.max_replicas
    min_replicas = var.min_replicas
    cooldown_period = var.cooldown_period

    cpu_utilization {
      target = var.target_cpu_utilization
    }
  }
}

resource "google_compute_region_instance_group_manager" "managed_instance_group_app" {
  name = var.instance_group_name

  base_instance_name = var.base_instance_name
  //zone = var.main_instance_group_zone
  distribution_policy_zones = var.distribution_policy_zones

  version {
    instance_template = google_compute_instance_template.instance_template_app.id
  }

  auto_healing_policies {
    health_check = google_compute_health_check.health_check_app
    initial_delay_sec = var.initial_delay_sec
  }
}