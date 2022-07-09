module "cloudsql" {
  source      = "../../modules/cloudsql"
  name_format = local.name_format[local.region]
  name        = var.name
  kms_key_id  = var.kms_key_id
  network     = var.network
  region      = local.region
}

