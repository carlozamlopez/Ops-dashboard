output "keyvault_id" {
  value = azurerm_key_vault.main.id
}

output "keyvault_name" {
  value = azurerm_key_vault.main.name
}

output "keyvault_uri" {
  description = "URI del Key Vault — usado por CSI Driver para conectarse"
  value       = azurerm_key_vault.main.vault_uri
}