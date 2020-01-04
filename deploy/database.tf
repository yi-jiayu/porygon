resource "google_sql_database_instance" "porygon" {
  database_version = "POSTGRES_11"
  region           = "asia-southeast1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "porygon" {
  name     = "porygon"
  instance = google_sql_database_instance.porygon.name
  password = var.db_password
}
