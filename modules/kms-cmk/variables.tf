variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "service_identities" {
  type = list(string)
}

variable "labels" {
  type = map(string)
}
