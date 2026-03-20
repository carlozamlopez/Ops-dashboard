output "mysql_server_name" {
  value = azurerm_mysql_flexible_server.main.name
}

output "mysql_fqdn" {
  description = "FQDN del servidor — con Private DNS resuelve a IP privada"
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "mysql_private_ip" {
  description = "IP privada del Private Endpoint — solo disponible si enable_private_endpoint = true"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.main[0].private_service_connection[0].private_ip_address : null
}

output "database_name" {
  value = azurerm_mysql_flexible_database.opsdb.name
}