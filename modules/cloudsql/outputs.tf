
output "id" {
  value = google_sql_database_instance.db.id
}

output "service_account_email" {
  value = google_sql_database_instance.db.service_account_email_address
}

output "connection_name" {
  value = google_sql_database_instance.db.connection_name
}

output "db" {
  value = google_sql_database_instance.db.name
}
