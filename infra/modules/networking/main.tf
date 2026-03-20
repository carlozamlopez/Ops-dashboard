# ── Módulo: networking ────────────────────────────────────────
# Crea: Resource Group, VNet, subnets, NSGs, Log Analytics
# Todos los demás módulos dependen de los outputs de este módulo

resource "azurerm_resource_group" "main" {
    name = "rg-${var.prefijo}-${var.ambiente}"
    location = var.location
    tags = local.tags  
}

# ── Log analytics con una retencion de 30 dias ──
resource "azurerm_log_analytics_workspace" "main" {
    name                = "law-${var.prefijo}-${var.ambiente}"
    resource_group_name = azurerm_resource_group.main.name
    location            = azurerm_resource_group.main.location
    sku                 = "PerGB2018"
    retention_in_days   = var.log_retention_days
    tags                = local.tags  
}

#── VNet principal ─────────────────────────────────────────────
resource "azurerm_virtual_network" "main" {
    name                = "vnet-${var.prefijo}-${var.ambiente}"
    resource_group_name = azurerm_resource_group.main.name
    location            = azurerm_resource_group.main.location
    address_space       = [var.vnet_cidr]
    tags                = local.tags  
}

# ── Subnets ────────────────────────────────────────────────────
resource "azurerm_subnet" "aks" {
    name                    = "snet-aks-${var.prefijo}-${var.ambiente}"
    resource_group_name     = azurerm_resource_group.main.name
    virtual_network_name    = azurerm_virtual_network.main.name
    address_prefixes        = [var.subnet_aks_cidr]  
}

resource "azurerm_subnet" "appgateway" {
    name                    = "snet-appgw-${var.prefijo}-${var.ambiente}"
    resource_group_name     = azurerm_resource_group.main.name
    virtual_network_name    = azurerm_virtual_network.main.name
    address_prefixes        = [var.subnet_appgw_cidr]  
}

resource "azurerm_subnet" "mysql" {
    name                    = "snet-mysql-${var.prefijo}-${var.ambiente}"
    resource_group_name     = azurerm_resource_group.main.name
    virtual_network_name    = azurerm_virtual_network.main.name
    address_prefixes        = [var.subnet_mysql_cidr]  

 # Requerido para Private Endpoint
  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_subnet" "management" {
    name                    = "snet-mgmt-${var.prefijo}-${var.ambiente}"
    resource_group_name     = azurerm_resource_group.main.name
    virtual_network_name    = azurerm_virtual_network.main.name
    address_prefixes        = [var.subnet_mgmt_cidr]  
}

# ── NSGs ────────────────────────────────────────────────────────

resource "azurerm_network_security_group" "aks" {
  name = "nsg-aks-${var.prefijo}-${var.ambiente}"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  tags = local.tags

  security_rule {
    name                       = "Allow-AppGW-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = var.subnet_appgw_cidr
    destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_group" "appgateway" {
  name                = "nsg-appgw-${var.prefijo}-${var.ambiente}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = local.tags

  # Regla OBLIGATORIA para App Gateway v2
  security_rule {
    name                       = "Allow-GatewayManager"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS-Inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

# ── NSG Associations ──────────────────────────────────────────
resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

resource "azurerm_subnet_network_security_group_association" "appgateway" {
  subnet_id                 = azurerm_subnet.appgateway.id
  network_security_group_id = azurerm_network_security_group.appgateway.id
}