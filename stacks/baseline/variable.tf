variable "name" {
  type = string
}

variable "activate_apis" {
  type = list(string)
}

variable "keys" {
  type        = list(string)
  description = "Name of your keys"
}

variable "service_identities" {
  type        = map(list(string))
  description = "Service identities for the key."
}
