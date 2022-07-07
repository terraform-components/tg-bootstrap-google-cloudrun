include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}//stacks/vpc"
}

# These inputs get merged with the common inputs from the root
inputs = {
  cidr_cloudrun = "10.1.0.0/28"

  cidr_service_networking = "10.128.0.0/16"
}
