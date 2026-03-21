# ── Módulo: AKS ───────────────────────────────────────────────
# Azure Kubernetes Service — cluster administrado
# Microsoft gestiona el control plane, tú gestionas los nodos

resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-${var.prefijo}-${var.ambiente}"
  resource_group_name = var.resource_group_name
  location            = var.location
  dns_prefix          = "${var.prefijo}-${var.ambiente}"

  # Identidad gestionada — AKS se autentica en Azure sin credenciales
  identity {
    type = "SystemAssigned"
  }

  # Node pool principal
  default_node_pool {
    name           = "system"
    node_count     = var.node_count
    vm_size        = var.node_vm_sku
    vnet_subnet_id = var.subnet_aks_id

    # Distribución en Availability Zones (prod: ["1","2","3"])
    zones = var.availability_zones
  }

    # Red — usa la VNet que creamos en networking
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  # Monitoreo — Log Analytics del módulo networking
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_id
  }

  # AGIC — Application Gateway Ingress Controller
  ingress_application_gateway {
    gateway_id = var.app_gateway_id
  }

  tags = var.tags
}