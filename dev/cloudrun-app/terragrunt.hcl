include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}//stacks/cloudrun-app"
}

dependency "baseline" {
  config_path = "../baseline"
}


dependency "database" {
  config_path = "../database"
}

dependency "vpc" {
  config_path = "../vpc"
}

# These inputs get merged with the common inputs from the root
inputs = {
  vpc_access_connector     = dependency.vpc.outputs.cloudrun_vpc_access_connector
  cloudsql_connection_name = dependency.database.outputs.connection_name
  cloudsql_db              = dependency.database.outputs.db
}
