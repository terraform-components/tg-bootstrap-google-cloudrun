variable "name_format" {
  type = object({
    name1 = string
  })
  default = {
    name1 = "%s"
  }
}

variable "region" {
  type        = string
  description = "Name is unique within the project across all regions and can not be used again for 2 weeks after deleting. This means be careful with deleting and use regional names when formatting."
}

variable "name" {
  type = string
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "iam_authentication" {
  type    = bool
  default = true
}

variable "network" {
  type    = string
  default = null
}

variable "database_version" {
  type    = string
  default = "POSTGRES_14"
}

variable "tier" {
  type    = string
  default = "db-f1-micro"
}

variable "availability_type" {
  type    = string
  default = "ZONAL"
}

variable "retained_backups" {
  type    = number
  default = 10
}

variable "transaction_log_retention_days" {
  type    = number
  default = 1
}

variable "deletion_protection" {
  type    = bool
  default = true
}
