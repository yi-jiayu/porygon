output "collector_url" {
  value = google_cloud_run_service.porygon.status[0].url
}

output "metabase_url" {
  value = "http://${google_compute_instance.metabase.network_interface.0.access_config.0.nat_ip}:8080"
}
