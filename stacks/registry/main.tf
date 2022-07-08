module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 13.0"
  activate_apis = [
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudkms.googleapis.com",
    "artifactregistry.googleapis.com",
  ]
  activate_api_identities     = []
  disable_services_on_destroy = true
  disable_dependent_services  = true
  project_id                  = local.project
}

# do not use default service accounts for anything
resource "google_project_default_service_accounts" "default_service_accounts" {
  action         = "DISABLE"
  restore_policy = "REVERT_AND_IGNORE_FAILURE"
  depends_on     = [module.project_services]
  project        = local.project
}

module "cmk" {
  source             = "github.com/terraform-components/tf-module-google-kms-cmk"
  name               = local.name_regional
  location           = local.region
  labels             = local.labels
  service_identities = ["artifactregistry.googleapis.com"]
  depends_on = [
    module.project_services,
  ]
}

# this is not ideal as this should be in a shared project
module "registry" {
  source     = "../../modules/docker-repository"
  name       = local.name_regional
  location   = local.region
  labels     = local.labels
  kms_key_id = module.cmk.kms_key_id
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
