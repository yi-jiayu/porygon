output "url" {
  value = google_cloud_run_service.porygon.status[0].url
}
