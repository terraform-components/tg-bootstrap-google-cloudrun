output "network" {
  value = google_compute_network.vpc.id
}

output "subnetworks" {
  value = {
    cloudrun = google_compute_subnetwork.cloudrun.id
  }
}

output "cloudrun_vpc_access_connector" {
  value = google_vpc_access_connector.cloudrun.id
}
