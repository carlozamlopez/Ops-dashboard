variable "prefijo" {
  description = "Prefijo del proyecto para naming convention"
  type = string
}

variable "ambiente" {
  description = "Ambiente: dev, staging, prod"
  type = string
  validation {
    condition = contains(["dev", "staging", "prod"], var.ambiente)
    error_message = "Ambiente debe ser dev, staging o prod."
  }
}

variable "location" {
    description = "Region de Azure"
    type = string
    default = "eastus"  
}

variable "vnet_cidr" {
    description = "CIDR de la VNet principal"
    type = string
    default = "10.0.0.0/16"
}

variable "subnet_aks_cidr" {
    description = "CIDR subnet AKS"
    type = string
    default = "10.0.1.0/24"
}

variable "subnet_appgw_cidr" {
    description = "CIDR subnet Application Gateway"
    type = string
    default = "10.0.2.0/24"
}

variable "subnet_mysql_cidr" {
    description = "CIDR subnet Application Gateway"
    type = string
    default = "10.0.3.0/24"
}

variable "subnet_mgmt_cidr" {
    description = "CIDR subnet management / Bastion"
    type = string
    default = "10.0.4.0/24"
}

variable "log_retention_days" {
    description = "Retención de logs en Log Analytics (días)"
    type = number
    default = 30
}

variable "tags_extra" {
    description = "Tags adicionales a mergear"
    type = map(string)
    default = {}
}