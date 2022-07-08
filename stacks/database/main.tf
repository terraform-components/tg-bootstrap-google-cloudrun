
module "cmk" {
  source             = "github.com/terraform-components/terraform-google-kms-cmk"
  name               = format(local.name_format[local.region], var.name)
  location           = local.region
  labels             = local.labels
  kms_key_ring_id    = var.kms_key_ring_id
  service_identities = ["sqladmin.googleapis.com"]
}

module "cloudsql" {
  source           = "../../modules/cloudsql"
  name             = format(local.name_format[local.region], var.name)
  kms_key_id       = module.cmk.kms_key_id
  network          = var.network
  database_version = "POSTGRES_13"
}
