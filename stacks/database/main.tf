module "cloudsql" {
  source     = "../../modules/cloudsql"
  name       = format(local.name_format[local.region], var.name)
  kms_key_id = var.kms_key_id
  network    = var.network
}
