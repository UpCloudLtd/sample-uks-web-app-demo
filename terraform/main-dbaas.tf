resource "upcloud_managed_database_mysql" "dbaas_mysql" {
  name = "mysql-wordpress-example"
  plan = var.mysql_plan
  zone = var.zone
}

resource "upcloud_managed_database_logical_database" "websitedb" {
  service = upcloud_managed_database_mysql.dbaas_mysql.id
  name    = "wordpress"
}

resource "upcloud_managed_database_user" "websiteuser" {
  service  = upcloud_managed_database_mysql.dbaas_mysql.id
  username = "wordpress"
}
resource "local_file" "mysql-user" {
  content  = upcloud_managed_database_user.websiteuser.username
  filename = "${path.module}/credentials/mysql-user.txt"
}
resource "local_file" "mysql-password" {
  content  = upcloud_managed_database_user.websiteuser.password
  filename = "${path.module}/credentials/mysql-password.txt"
}
resource "local_file" "mysql-hostname" {
  content  = "${upcloud_managed_database_mysql.dbaas_mysql.service_host}:${upcloud_managed_database_mysql.dbaas_mysql.service_port}"
  filename = "${path.module}/credentials/mysql-hostname.txt"
}
resource "local_file" "mysql-database-name" {
  content  = upcloud_managed_database_logical_database.websitedb.name
  filename = "${path.module}/credentials/mysql-db-name.txt"
}