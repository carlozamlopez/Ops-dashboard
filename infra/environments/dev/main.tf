# ── Environment: DEV ──────────────────────────────────────────
# Orquestador — llama a todos los módulos en orden correcto
# terraform init && terraform plan && terraform apply

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-backend"
    storage_account_name = "stterraformbackendmx"
    container_name       = "tfstate"
    key                  = "ops-dashboard/dev/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

# ── Módulo: Networking ────────────────────────────────────────
module "networking" {
  source   = "../../modules/networking"
  prefijo  = var.prefijo
  ambiente = var.ambiente
  location = var.location

  vnet_cidr         = "10.10.0.0/16"
  subnet_aks_cidr   = "10.10.1.0/24"
  subnet_appgw_cidr = "10.10.2.0/24"
  subnet_mysql_cidr = "10.10.3.0/24"
  subnet_mgmt_cidr  = "10.10.4.0/24"

  log_retention_days = 30
  tags_extra         = local.tags_extra
}

# ── Módulo: ACR ────────────────────────────────────────────────
module "acr" {
  source              = "../../modules/acr"
  prefijo             = var.prefijo
  ambiente            = var.ambiente
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  sku                 = "Basic"
  aks_principal_id    = module.aks.kubelet_identity_object_id
}

# ── Módulo: MySQL ──────────────────────────────────────────────
# module "mysql" {
#   source              = "../../modules/mysql"
#   prefijo             = var.prefijo
#   ambiente            = var.ambiente
#   location            = var.location
#   resource_group_name = module.networking.resource_group_name
#   vnet_id             = module.networking.vnet_id
#   subnet_mysql_id     = module.networking.subnet_mysql_id

#   db_admin_password       = var.db_admin_password
#   sku_name                = "B_Standard_B1ms"
#   backup_retention_days   = 7
#   enable_ha               = false
#   enable_private_endpoint = false
#   tags                    = local.tags_extra
# }

# ── Módulo: App Gateway ───────────────────────────────────────
module "appgateway" {
  source              = "../../modules/appgateway"
  prefijo             = var.prefijo
  ambiente            = var.ambiente
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  subnet_appgw_id     = module.networking.subnet_appgw_id
  sku_name            = "Standard_v2"
  sku_tier            = "Standard_v2"
  capacity            = 1
  tags                = local.tags_extra
}

# ── Módulo: AKS ───────────────────────────────────────────────
module "aks" {
  source              = "../../modules/aks"
  prefijo             = var.prefijo
  ambiente            = var.ambiente
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  subnet_aks_id       = module.networking.subnet_aks_id
  log_analytics_id    = module.networking.log_analytics_workspace_id
  acr_id              = module.acr.acr_id
  app_gateway_id      = module.appgateway.appgw_id

  node_count          = 1
  node_vm_sku         = "Standard_DC2s_v3"
  availability_zones  = []
  tags                = local.tags_extra
}

# ── Módulo: Key Vault ─────────────────────────────────────────
module "keyvault" {
  source              = "../../modules/keyvault"
  prefijo             = var.prefijo
  ambiente            = var.ambiente
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  aks_principal_id    = module.aks.kubelet_identity_object_id

  secrets = {
     # MySQL secrets — descomentar cuando MySQL esté activo
    #"db-password"   = var.db_admin_password
    #"db-host"       = module.mysql.mysql_fqdn
    #"db-name"       = module.mysql.database_name
    "db-admin-user" = "opsadmin"
  }
  tags = local.tags_extra
}