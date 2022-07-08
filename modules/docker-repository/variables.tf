variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "kms_key_id" {
  type = string
}

variable "labels" {
  type = map(string)
}
