
output "acr_id" {
  description = "ID del ACR — usado para asignar roles RBAC"
  value = azurerm_container_registry.main.id  
}

output "acr_name" {
  description = "Nombre del ACR — usado en el pipeline de GitHub Actions"
  value = azurerm_container_registry.main.name  
}

output "acr_login_server" {
  description = "URL del registry — ej: acropsdashboarddev.azurecr.io"
  value       = azurerm_container_registry.main.login_server
}