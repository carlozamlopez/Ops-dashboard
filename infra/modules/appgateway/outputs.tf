output "appgw_id" {
  description = "ID del App Gateway — requerido por el módulo AKS para AGIC"
  value       = azurerm_application_gateway.main.id
}

output "appgw_name" {
  value = azurerm_application_gateway.main.name
}

output "public_ip_address" {
  description = "IP pública del App Gateway — la que apunta al dominio"
  value       = azurerm_public_ip.appgw.ip_address
}