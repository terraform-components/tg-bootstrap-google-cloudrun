
resource "google_compute_global_address" "private_ip" {
  name          = "${var.name}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = split("/", var.cidr_service_networking)[0]
  prefix_length = split("/", var.cidr_service_networking)[1]
  network       = var.network
}

resource "google_service_networking_connection" "private_ip_vpc_connection" {
  network = var.network
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private_ip.name
  ]
}
