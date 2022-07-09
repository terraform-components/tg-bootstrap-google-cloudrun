include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}//stacks/database"
}

dependency "baseline" {
  config_path = "../baseline"
}

dependency "vpc" {
  config_path = "../vpc"
}

# These inputs get merged with the common inputs from the root
inputs = {
  kms_key_id = dependency.baseline.outputs.kms_key_ids["database"]
  name       = "db2"
  network    = dependency.vpc.outputs.network
}
