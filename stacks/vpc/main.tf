
resource "google_compute_network" "vpc" {
  name                    = local.name_global
  auto_create_subnetworks = false
}

module "service_networking" {
  source                  = "../../modules/network-service-networking"
  name                    = "service-networking"
  cidr_service_networking = var.cidr_service_networking
  network                 = google_compute_network.vpc.id
}

resource "google_compute_subnetwork" "cloudrun" {
  network                  = google_compute_network.vpc.id
  name                     = format(local.name_format[local.region], "cloudrun")
  ip_cidr_range            = var.cidr_cloudrun
  private_ip_google_access = true
}

resource "google_vpc_access_connector" "cloudrun" {
  provider = google-beta
  name     = format(local.name_format[local.region], "cloudrun")
  region   = local.region

  subnet {
    name = google_compute_subnetwork.cloudrun.name
  }

  lifecycle {
    ignore_changes = [network]
  }
}
