variable "name" {
  type = string
}

variable "network" {
  type    = string
  default = null
}

variable "kms_key_ring_id" {
  type = string
}
