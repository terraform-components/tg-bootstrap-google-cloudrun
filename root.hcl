locals {
  # Automatically load context-level variables
  context_vars = read_terragrunt_config(find_in_parent_folders("context.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  region  = local.context_vars.locals.region
  project = local.environment_vars.locals.project
}

# Generate a GCP provider block
generate "provider" {
  path      = "main.provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google-beta" {
  project = local.project
  region = local.region
}

provider "google" {
  project = local.project
  region = local.region
}
EOF
}



generate "locals" {
  path      = "main.locals.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
locals {
  name_format   = module.context.format
  context       = module.context.context
  region        = "${local.region}"
  project       = "${local.project}"
  labels        = {} # TBD
}

module "context" {
  source                  = "github.com/terraform-components/terraform-null-context"
  location_abbreviations  = module.locations.abbreviations
  # we don't want those prefixes here, but they can be very useful
  context                 = {
    namespace   = null
    environment = null
  }
}

module "locations" {
  source = "github.com/terraform-components/terraform-google-locations"
}

EOF
}

remote_state {
  backend = "gcs"
  config = {
    project                   = local.project
    location                  = local.region
    bucket                    = "${local.project}-tfstate"
    prefix                    = "${path_relative_to_include()}.tfstate"
    enable_bucket_policy_only = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
  local.context_vars.locals,
  local.environment_vars.locals,
)
