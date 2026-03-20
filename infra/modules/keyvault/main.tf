# ── Módulo: Key Vault ─────────────────────────────────────────
# Centraliza secretos — DB password, connection strings
# Los pods consumen secretos via CSI Driver (sin env vars)

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                = "kv-${var.prefijo}-${var.ambiente}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  # Soft delete — si alguien borra el KV por error, se puede recuperar
  soft_delete_retention_days = 7

  # Purge protection — nadie puede eliminar permanentemente
  # incluso con permisos de Owner
  purge_protection_enabled = var.ambiente == "prod" ? true : false

  # RBAC — Zero Trust, no Access Policies legacy
  rbac_authorization_enabled = true

  tags = var.tags
}

# Secretos de la aplicación
resource "azurerm_key_vault_secret" "secrets" {
  for_each = var.secrets

  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_role_assignment.terraform_admin
  ]
}

# Permiso para que Terraform pueda escribir secretos
resource "azurerm_role_assignment" "terraform_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Permiso para que AKS lea secretos via CSI Driver
resource "azurerm_role_assignment" "aks_secrets_reader" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.aks_principal_id
}