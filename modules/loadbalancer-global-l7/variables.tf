variable "name_format" {
  type = object({
    name1 = string
  })
  default = {
    name1 = "%s"
  }
}

variable "name" {
  type = string
}

variable "domains" {
  type        = map(list(string))
  description = "map of list to have multiple certificates"
}

variable "cdn" {
  type    = bool
  default = false
}

variable "backend_network_endpoint_group_id" {
  type = string
}

variable "ip_address" {
  type = string
}

variable "security_policy" {
  type    = string
  default = null
}

variable "ssl_certificates" {
  type = list(string)
}

variable "ssl_policy_profile" {
  type    = string
  default = "MODERN"
}

variable "min_tls_version" {
  type    = string
  default = "TLS_1_2"
}

variable "backend_service_protocol" {
  type    = string
  default = "HTTPS"
}

variable "backend_service_timeout_sec" {
  type    = number
  default = 30
}

variable "backend_service_connection_draining_timeout_sec" {
  type    = number
  default = 30
}
