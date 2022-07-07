
module "cmk" {
  source             = "../../modules/kms-cmk"
  name               = local.name_regional
  location           = local.region
  labels             = local.labels
  service_identities = ["sqladmin.googleapis.com"]
}

module "cloudsql" {
  source           = "../../modules/cloudsql"
  name             = local.name_regional
  kms_key_id       = module.cmk.kms_key_id
  network          = var.network
  database_version = "POSTGRES_13"
}
