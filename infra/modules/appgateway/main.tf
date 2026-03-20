# ── Módulo: Application Gateway ───────────────────────────────
# App Gateway v2 con AGIC — resuelve el problema de LB L4
# WAF activo en prod, Standard en dev/staging

# IP pública del App Gateway — punto de entrada de internet
resource "azurerm_public_ip" "appgw" {
  name                = "pip-appgw-${var.prefijo}-${var.ambiente}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_application_gateway" "main" {
  name                = "appgw-${var.prefijo}-${var.ambiente}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  # SKU — Standard_v2 en dev/staging, WAF_v2 en prod
  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.capacity
  }

  # Subnet dedicada para el App Gateway
  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.subnet_appgw_id
  }

  # IP pública — lo que ve internet
  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  # Puerto de entrada
  frontend_port {
    name = "port-80"
    port = 80
  }

  # Backend pool — AGIC lo gestiona automáticamente
  # No necesitamos definir IPs manualmente
  backend_address_pool {
    name = "appgw-backend-pool"
  }

  # Configuración HTTP hacia los pods
  backend_http_settings {
    name                  = "appgw-backend-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30

    # Health probe — verifica que los pods estén sanos
    probe_name = "appgw-health-probe"
  }

  # Health probe — llama a /health de los servicios
  probe {
    name                = "appgw-health-probe"
    protocol            = "Http"
    path                = "/health"
    interval            = 30
    timeout             = 10
    unhealthy_threshold = 3
    host                = "127.0.0.1"
  }

  # Listener — escucha tráfico HTTP en puerto 80
  http_listener {
    name                           = "appgw-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "port-80"
    protocol                       = "Http"
  }

  # Regla de routing — conecta listener con backend
  request_routing_rule {
    name                       = "appgw-routing-rule"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = "appgw-listener"
    backend_address_pool_name  = "appgw-backend-pool"
    backend_http_settings_name = "appgw-backend-settings"
  }

  # WAF — solo activo en prod via variable
  dynamic "waf_configuration" {
    for_each = var.sku_tier == "WAF_v2" ? [1] : []
    content {
      enabled          = true
      firewall_mode    = "Prevention"
      rule_set_type    = "OWASP"
      rule_set_version = "3.2"
    }
  }

  lifecycle {
    ignore_changes = [
      # AGIC modifica estos valores automáticamente
      # Sin esto Terraform los sobreescribiría en cada apply
      backend_address_pool,
      backend_http_settings,
      http_listener,
      probe,
      request_routing_rule,
      tags
    ]
  }
}