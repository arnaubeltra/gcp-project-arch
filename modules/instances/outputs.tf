output "managed_instance_group" {
  value = google_compute_region_instance_group_manager.managed_instance_group_app.instance_group
}