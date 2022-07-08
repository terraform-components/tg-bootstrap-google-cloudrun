output "service_account_email" {
  value = module.cloudsql.service_account_email
}

output "connection_name" {
  value = module.cloudsql.connection_name
}

output "db" {
  value = module.cloudsql.db
}
