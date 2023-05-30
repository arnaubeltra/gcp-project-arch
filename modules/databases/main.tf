resource "google_sql_database_instance" "name" {
  name = var.database_name
  database_version = var.database_version
  region = var.database_region

  settings {
    tier = var.database_tier

    ip_configuration {
      ipv4_enabled = false
      private_network = var.network
      enable_private_path_for_google_cloud_services = true
    }

  }
}