
module "service_account" {
  source  = "github.com/terraform-components/terraform-google-service-account"
  name    = "application"
  project = local.project
}

module "cloudrun" {
  source                   = "github.com/terraform-components/terraform-google-cloudrun"
  service_account_email    = module.service_account.email
  name                     = format(local.name_format[local.region], var.name)
  region                   = local.region
  vpc_access_connector     = var.vpc_access_connector
  cloudsql_connection_name = var.cloudsql_connection_name

  environment_variables = {
    "INSTANCE_CONNECTION_NAME" = var.cloudsql_connection_name
    "DB_USER"                  = google_sql_user.iam_user.name
    "DB_NAME"                  = "postgres"
  }
}

resource "google_compute_global_address" "ingress" {
  name = format(local.name_format["global"], var.name)
}

resource "google_compute_managed_ssl_certificate" "ingress" {
  for_each = var.domains
  provider = google-beta

  name = replace(each.key, ".", "-")

  managed {
    domains = each.value
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "ingress" {
  source                            = "../../modules/loadbalancer-global-l7"
  name                              = format(local.name_format["global"], var.name)
  ip_address                        = google_compute_global_address.ingress.address
  backend_network_endpoint_group_id = module.cloudrun.network_endpoint_group_id
  domains                           = var.domains
  ssl_certificates                  = [for _, certificate in google_compute_managed_ssl_certificate.ingress : certificate.id]
}

resource "google_sql_user" "iam_user" {
  name     = trimsuffix(module.service_account.email, ".gserviceaccount.com")
  instance = var.cloudsql_db
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}

resource "google_project_iam_member" "iam_user_cloudsql_instance_user" {
  role    = "roles/cloudsql.instanceUser"
  project = local.project
  member  = "serviceAccount:${module.service_account.email}"
}

resource "google_project_iam_member" "iam_user_cloudsql_client" {
  role    = "roles/cloudsql.client"
  project = local.project
  member  = "serviceAccount:${module.service_account.email}"
}
