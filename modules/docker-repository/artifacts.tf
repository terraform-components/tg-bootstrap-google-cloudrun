resource "google_artifact_registry_repository" "docker" {
  provider      = google-beta
  location      = var.location
  repository_id = "docker-${var.name}"
  format        = "DOCKER"
  kms_key_name  = var.kms_key_id
  labels        = var.labels
}
