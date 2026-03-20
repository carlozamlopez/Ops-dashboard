output "mysql_server_name" {
  value = azurerm_mysql_flexible_server.main.name
}

output "mysql_fqdn" {
  description = "FQDN del servidor — con Private DNS resuelve a IP privada"
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "mysql_private_ip" {
  description = "IP privada asignada por el Private Endpoint"
  value       = azurerm_private_endpoint.mysql.private_service_connection[0].private_ip_address
}

output "database_name" {
  value = azurerm_mysql_flexible_database.opsdb.name
}