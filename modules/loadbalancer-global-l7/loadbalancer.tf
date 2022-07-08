resource "google_compute_backend_service" "this" {
  name                            = var.name
  protocol                        = var.backend_service_protocol
  timeout_sec                     = var.backend_service_timeout_sec
  connection_draining_timeout_sec = var.backend_service_connection_draining_timeout_sec
  enable_cdn                      = var.cdn
  security_policy                 = var.security_policy
  backend {
    group = var.backend_network_endpoint_group_id
  }
}

resource "google_compute_url_map" "this" {
  name            = var.name
  default_service = google_compute_backend_service.this.id # TBD

  host_rule {
    hosts        = distinct(flatten([for _, v in var.domains : v]))
    path_matcher = "paths"
  }

  path_matcher {
    name            = "paths"
    default_service = google_compute_backend_service.this.id

    # TBD: actual matching

    # TBD maintenance page option

  }
}

resource "google_compute_target_https_proxy" "this" {
  name             = var.name
  url_map          = google_compute_url_map.this.id
  ssl_certificates = var.ssl_certificates
  ssl_policy       = google_compute_ssl_policy.this.name
}

resource "google_compute_ssl_policy" "this" {
  name            = var.name
  profile         = var.ssl_policy_profile
  min_tls_version = var.min_tls_version
}

resource "google_compute_global_forwarding_rule" "this" {
  name       = var.name
  target     = google_compute_target_https_proxy.this.id
  port_range = "443"
  ip_address = var.ip_address
}
