# ── Módulo: mysql ─────────────────────────────────────────────
# Azure Database for MySQL Flexible Server + Private Endpoint
# Acceso SOLO privado — public access deshabilitado (Zero Trust)

resource "azurerm_mysql_flexible_server" "main" {
  name                   = "mysql-${var.prefijo}-${var.ambiente}"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.db_admin_user
  administrator_password = var.db_admin_password
  sku_name               = var.sku_name
  version                = "8.0.21"
  #zone                   = "1"
  
  dynamic "high_availability" {
    for_each = var.enable_ha ? [1] : []
    content {
      mode = "ZoneRedundant"
      standby_availability_zone = "2"
    }
  }
  backup_retention_days = var.backup_retention_days
  geo_redundant_backup_enabled = var.ambiente == "prod" ? true : false

  tags = var.tags
}

# ── Private Endpoint ───────────────────────────────────────────

resource "azurerm_private_endpoint" "main" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                  = "pe-mysql-${var.prefijo}-${var.ambiente}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  subnet_id             = var.subnet_mysql_id

  private_service_connection {
    name                              = "psc-${var.prefijo}-${var.ambiente}"
    private_connection_resource_id    = azurerm_mysql_flexible_server.main.id
    subresource_names                 = ["mysqlServer"]
    is_manual_connection              = false
  }

  private_dns_zone_group {
    name = "mysql-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.mysql[0].id]
  }

  tags = var.tags
}

# ── Private DNS Zone ───────────────────────────────────────────
# Sin esto el FQDN de MySQL resuelve a IP pública
# Con esto resuelve a la IP privada del Private Endpoint
resource "azurerm_private_dns_zone" "mysql" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  count                 = var.enable_private_endpoint ? 1 : 0
  name                  = "dns-link-mysql-${var.prefijo}-${var.ambiente}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.mysql[0].name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

# Base de datos de la aplicación
resource "azurerm_mysql_flexible_database" "opsdb" {
  name                = "opsdb"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}