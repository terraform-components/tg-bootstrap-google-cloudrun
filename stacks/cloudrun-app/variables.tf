variable "vpc_access_connector" {
  type = string
}

variable "cloudsql_db" {
  type = string
}

variable "cloudsql_connection_name" {
  type = string
}

variable "domains" {
  type = map(list(string))
}
