output "kms_key_ring_id" {
  value = google_kms_key_ring.this.id
}

output "kms_key_ids" {
  value = module.keys.kms_key_ids
}
