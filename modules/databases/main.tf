# Database was suposed to only have private IP address, but due to organizational permissions
# it will have a public IP address, as I cannot set a static IP address. All code disabled
# below it will be for this reason.

/*resource "google_compute_global_address" "private_ip_address" {
  name          = var.private_ip_address_name
  address_type  = "INTERNAL"
  prefix_length = var.prefix_length
  network       = var.network
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
*/

resource "google_sql_database_instance" "database_master" {
  name                = var.database_name
  region              = var.database_region
  database_version    = var.database_version
  deletion_protection = false
  #depends_on          = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = var.database_tier
    availability_type = var.availability_type
    disk_size         = var.disk_size

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }

    ip_configuration {
      ipv4_enabled = true
      #ipv4_enabled                                  = false
      #private_network                               = var.network
      #enable_private_path_for_google_cloud_services = true
    }
  }
}

resource "google_sql_database_instance" "read_replica" {
  name                 = var.database_read_replica_name
  master_instance_name = google_sql_database_instance.database_master.name
  region               = var.read_replica_region
  database_version     = var.database_version
  deletion_protection  = false
  #depends_on           = [google_service_networking_connection.private_vpc_connection]

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = var.database_tier
    availability_type = var.availability_type
    disk_size         = var.disk_size

    # Check if this part is necessary in a Read-replica
    /*backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }*/

    ip_configuration {
      ipv4_enabled = true
      #ipv4_enabled                                  = false
      #private_network                               = var.network
      #enable_private_path_for_google_cloud_services = true
    }
  }
}