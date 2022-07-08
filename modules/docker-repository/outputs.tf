output "id" {
  value = google_artifact_registry_repository.docker.id
}

output "repository" {
  value = "${var.location}-docker.pkg.dev/${var.project}/docker-${var.name}"
}
