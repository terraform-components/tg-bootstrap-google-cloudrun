resource "google_cloud_run_service" "main" {
  name                       = var.name
  location                   = var.region
  autogenerate_revision_name = true

  lifecycle {
    # those things are usually not managed in terraform, but your use case may be different
    ignore_changes = [
      template[0].spec[0].containers[0].image,
      template[0].metadata[0].annotations["client.knative.dev/user-image"],
      template[0].metadata[0].annotations["run.googleapis.com/client-name"],
      template[0].metadata[0].annotations["run.googleapis.com/client-version"],
      traffic,
      metadata[0].annotations["client.knative.dev/user-image"],
      metadata[0].annotations["run.googleapis.com/client-name"],
      metadata[0].annotations["run.googleapis.com/client-version"],
    ]
  }

  template {
    spec {
      service_account_name  = var.service_account_email
      container_concurrency = var.container_concurrency
      containers {
        image = var.container_initial_image
      }
    }

    metadata {
      annotations = {
        "run.googleapis.com/client-name"           = "terraform"
        "run.googleapis.com/execution-environment" = var.execution_environment
        "autoscaling.knative.dev/minScale"         = var.min_scale
        "autoscaling.knative.dev/maxScale"         = var.max_scale
        "run.googleapis.com/vpc-access-connector"  = var.vpc_access_connector
        "run.googleapis.com/vpc-access-egress"     = var.vpc_access_connector != null ? var.vpc_access_egress : null
        "run.googleapis.com/cloudsql-instances"    = var.cloudsql_connection_name
      }
    }
  }

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = var.ingress
    }
  }
}
