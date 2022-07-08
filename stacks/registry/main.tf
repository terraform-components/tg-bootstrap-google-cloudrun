# this is not ideal as this should be in a shared project
module "registry" {
  source     = "../../modules/docker-repository"
  name       = format(local.name_format[local.region], var.name)
  location   = local.region
  labels     = local.labels
  project    = local.project
  kms_key_id = var.kms_key_id
  depends_on = [module.cmk]
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
