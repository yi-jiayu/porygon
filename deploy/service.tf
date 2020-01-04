resource "google_cloud_run_service" "porygon" {
  name     = "porygon"
  location = "us-central1"

  template {
    spec {
      containers {
        image = var.image
        env {
          name  = "ROCKET_DATABASES"
          value = "{porygon={url=\"postgres://porygon:dPYHo9VKt9cA9tU2C7ubwVKgQUwy3Xex@/porygon?host=/cloudsql/infra-251203:asia-southeast1:terraform-20200104115334699800000001\"}}"
        }
      }
    }

    metadata {
      annotations = {
        "run.googleapis.com/cloudsql-instances" = "${var.project}:${var.region}:${google_sql_database_instance.porygon.name}"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.porygon.location
  project  = google_cloud_run_service.porygon.project
  service  = google_cloud_run_service.porygon.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

