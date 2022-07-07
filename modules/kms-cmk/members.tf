resource "google_project_service_identity" "this" {
  for_each = toset(var.service_identities)
  provider = google-beta
  service  = each.key
}

resource "google_kms_crypto_key_iam_binding" "this" {
  crypto_key_id = google_kms_crypto_key.this.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members       = [for service in toset(var.service_identities) : "serviceAccount:${google_project_service_identity.this[service].email}"]

  depends_on = [
    google_project_service_identity.this
  ]
}
