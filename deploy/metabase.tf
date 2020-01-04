module "gce-advanced-container" {
  source = "github.com/terraform-google-modules/terraform-google-container-vm"

  container = {
    image = "metabase/metabase"
    env = [
      {
        name  = "MB_JETTY_PORT"
        value = "8080"
      }
    ]
  }

  restart_policy = "Always"
}

resource "google_compute_instance" "metabase" {
  project      = var.project
  name         = "metabase"
  machine_type = "n1-standard-1"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = module.gce-advanced-container.source_image
    }
  }

  metadata = {
    gce-container-declaration = module.gce-advanced-container.metadata_value
  }

  labels = {
    container-vm = module.gce-advanced-container.vm_container_label
  }

  network_interface {
    network = google_compute_network.porygon.self_link

    access_config {}
  }
}
