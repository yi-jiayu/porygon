resource "google_cloud_run_service" "porygon" {
  name     = "porygon"
  location = "us-central1"

  template {
    spec {
      containers {
        image = var.image
        env {
          name  = "ROCKET_DATABASES"
          value = "{porygon={url=\"postgres://${google_sql_user.porygon.name}:${google_sql_user.porygon.password}@/${google_sql_database.porygon.name}?host=/cloudsql/${google_sql_database_instance.porygon.connection_name}\"}}"
        }
      }
    }

    metadata {
      annotations = {
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.porygon.connection_name
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
