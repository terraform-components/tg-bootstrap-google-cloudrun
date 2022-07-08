
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

resource "google_compute_global_address" "ingress" {
  name = local.name_global
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
  name                              = local.name_global
  ip_address                        = google_compute_global_address.ingress.address
  backend_network_endpoint_group_id = module.cloudrun.network_endpoint_group_id
  domains                           = var.domains
  ssl_certificates                  = [for _, certificate in google_compute_managed_ssl_certificate.ingress : certificate.id]
}
