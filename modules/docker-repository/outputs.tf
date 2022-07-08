output "id" {
  value = google_artifact_registry_repository.docker.id
}

output "repository" {
  value = "${var.location}-docker.pkg.dev/${data.google_project.current.project_id}/docker-${var.name}"
}
