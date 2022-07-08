
module "service_account" {
  source  = "github.com/terraform-components/tf-module-google-service-account"
  name    = "application"
  project = local.project
}

module "cloudrun" {
  source                   = "github.com/terraform-components/tf-module-google-cloudrun"
  service_account_email    = module.service_account.email
  name                     = local.name_regional
  region                   = local.region
  vpc_access_connector     = var.vpc_access_connector
  cloudsql_connection_name = var.cloudsql_connection_name
}

