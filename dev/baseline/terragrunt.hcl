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
    "compute.googleapis.com",
    "run.googleapis.com",
    "vpcaccess.googleapis.com",
    "deploymentmanager.googleapis.com",
    "cloudbuild.googleapis.com",
    "sqladmin.googleapis.com",
    "cloudtasks.googleapis.com",
    "appengine.googleapis.com",
    "iap.googleapis.com",
    "redis.googleapis.com",
    "cloudkms.googleapis.com",
    "artifactregistry.googleapis.com",
  ]

  keys = [
    "database",
  ]

  service_identities = {
    database = ["sqladmin.googleapis.com"]
  }
}
