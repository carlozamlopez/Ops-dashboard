# ── Módulo: ACR ───────────────────────────────────────────────
# Azure Container Registry — almacena imágenes Docker privadas
# AKS tiene permiso de pull via managed identity

resource "azurerm_container_registry" "main" {
  name = "acr${var.prefijo}${var.ambiente}"
  resource_group_name = var.resource_group_name
  location = var.location
  sku = var.sku
  admin_enabled = false

  tags = var.tags
}

# Permiso para que AKS haga pull de imágenes del ACR
# Sin esto AKS no puede descargar las imágenes
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = var.aks_principal_id
}