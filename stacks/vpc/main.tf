
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

resource "google_compute_firewall" "serverless_health_checks" {
  name          = "serverless-health-checks"
  network       = google_compute_network.vpc.id
  description   = "Allow access for serverless to vpc connector health checks ${var.name}"
  direction     = "INGRESS"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "108.170.220.0/23"]
  target_tags   = ["vpc-connector-${local.region}-${google_vpc_access_connector.cloudrun.name}"]

  allow {
    protocol = "tcp"
    ports    = ["667"]
  }
}

resource "google_compute_firewall" "vpc_connector_to_serverless" {
  name               = "vpc-connector-to-serverless"
  network            = google_compute_network.vpc.id
  description        = "Allow access vpc connector to serverless ${var.name}"
  direction          = "EGRESS"
  destination_ranges = ["107.178.230.64/26", "35.199.224.0/19"]
  target_tags        = ["vpc-connector-${local.region}-${google_vpc_access_connector.cloudrun.name}"]

  allow {
    protocol = "tcp"
    ports    = ["667"]
  }

  allow {
    protocol = "udp"
    ports    = ["665-666"]
  }

  allow {
    protocol = "icmp"
  }
}

# may need to be more restrictive
resource "google_compute_firewall" "vpc_connector_allow_internal" {
  name        = "vpc-connector-allow-internal"
  network     = google_compute_network.vpc.id
  description = "allow to internal"
  direction   = "EGRESS"

  priority = 20000

  target_tags = ["vpc-connector-${local.region}-${google_vpc_access_connector.cloudrun.name}"]

  destination_ranges = [
    "10.0.0.0/8",
  ]

  allow {
    protocol = "all"
  }
}
