variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "service_account_email" {
  type = string
}

variable "invokers" {
  type    = list(string)
  default = ["allUsers"]
}

variable "ingress" {
  type    = string
  default = "internal-and-cloud-load-balancing"
}

variable "execution_environment" {
  type    = string
  default = "gen1"
}

variable "container_concurrency" {
  type    = number
  default = 100
}

variable "container_initial_image" {
  type    = string
  default = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "min_scale" {
  type    = number
  default = 0
}

variable "max_scale" {
  type    = number
  default = 5
}

variable "vpc_access_egress" {
  type    = string
  default = "private-ranges-only"
}

variable "vpc_access_connector" {
  type    = string
  default = null
}

variable "cloudsql_connection_name" {
  type    = string
  default = null
}
