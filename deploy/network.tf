resource "google_compute_network" "porygon" {
  name = "porygon"
}

resource "google_compute_firewall" "porygon" {
  name    = "porygon"
  network = google_compute_network.porygon.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "8080"]
  }
}
