include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}//stacks/database"
}

dependency "vpc" {
  config_path = "../vpc"
}

# These inputs get merged with the common inputs from the root
inputs = {
  name    = "db123"
  network = dependency.vpc.outputs.network
}
