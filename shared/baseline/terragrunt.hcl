include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}//stacks/baseline"
}

inputs = {
  activate_apis = [
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudkms.googleapis.com",
    "artifactregistry.googleapis.com",
  ]

  keys = [
    "registry"
  ]

  service_identities = {
    registry = ["artifactregistry.googleapis.com"]
  }
}
