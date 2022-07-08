include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_path_to_repo_root()}//stacks/registry"
}

dependency "baseline" {
  config_path = "../baseline"
}


inputs = {
  kms_key_ring_id = dependency.baseline.outputs.kms_key_ring_id
}
