resource "google_kms_key_ring" "this" {
  name     = var.name
  location = local.region
}

module "project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 13.0"
  activate_apis               = var.activate_apis
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
