variable "name" {
  type        = string
  description = "Names of docker artifact registries are local to the region they are in, so you can name them all the same if you choose to."
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

variable "project" {
  type = string
}
