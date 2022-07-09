locals {
  name = format(local.name_format["global"].name1, var.name)
}

# this is not ideal as this should be in a shared project
module "registry" {
  source     = "../../modules/docker-repository"
  name       = local.name
  location   = local.region
  labels     = local.labels
  project    = local.project
  kms_key_id = var.kms_key_id
}

# make it public
resource "google_artifact_registry_repository_iam_member" "docker_public" {
  provider   = google-beta
  project    = local.project
  location   = local.region
  repository = module.registry.id
  role       = "roles/viewer"
  member     = "allAuthenticatedUsers"
}
