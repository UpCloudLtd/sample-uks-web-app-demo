output "mysql_host" {
  value = upcloud_managed_database_mysql.dbaas_mysql.service_host
}

output "mysql_port" {
  value = upcloud_managed_database_mysql.dbaas_mysql.service_port
}

output "mysql_db_name" {
  value = upcloud_managed_database_logical_database.websitedb.name
}

output "mysql_user" {
  value = upcloud_managed_database_user.websiteuser.username
}
output "mysql_pass" {
  value = nonsensitive(upcloud_managed_database_user.websiteuser.password)
}
