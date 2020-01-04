provider "google" {
  credentials = file(var.key_file)
  project     = var.project
  region      = var.region
}
