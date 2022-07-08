module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 13.0"
  activate_apis = [
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "run.googleapis.com",
    "vpcaccess.googleapis.com",
    "deploymentmanager.googleapis.com",
    "cloudbuild.googleapis.com",
    "sqladmin.googleapis.com",
    "cloudtasks.googleapis.com",
    "appengine.googleapis.com",
    "iap.googleapis.com",
    "redis.googleapis.com",
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
