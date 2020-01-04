resource "google_compute_global_address" "porygon_db" {
  name          = "porygon-db"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.porygon.self_link
}

resource "google_service_networking_connection" "porygon_db" {
  network                 = google_compute_network.porygon.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.porygon_db.name]
}

resource "google_sql_database_instance" "porygon" {
  database_version = "POSTGRES_11"
  region           = "asia-southeast1"

  depends_on = [google_service_networking_connection.porygon_db]

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.porygon.self_link
    }
  }
}

resource "google_sql_user" "porygon" {
  name     = "porygon"
  instance = google_sql_database_instance.porygon.name
  password = var.db_password
}
