
variable "prefijo" {
  type = string  
}

variable "ambiente" {
  type = string  
}

variable "location" {
  type = string  
}

variable "resource_group_name" {
  type = string  
}

variable "vnet_id" {
  description = "ID de la VNet — para enlazar el Private DNS Zone"
  type        = string
}

variable "subnet_mysql_id" {
  description = "ID de la subnet MySQL para el Private Endpoint"
  type        = string
}

variable "db_admin_user" {
  description = "Usuario administrador de MySQL"
  type        = string
  default     = "opsadmin"
}

variable "db_admin_password" {
  description = "Password admin MySQL — viene de Key Vault, nunca hardcodeado"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "SKU del servidor MySQL. dev: B_Standard_B1ms | prod: GP_Standard_D4ds_v4"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "backup_retention_days" {
  type    = number
  default = 7
}

variable "enable_ha" {
  description = "Zone Redundant HA — solo para prod"
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = "Habilitar Private Endpoint. Requiere SKU General Purpose o superior. Dev usa false con Burstable."
  type        = bool
  default     = true
}

variable "tags" {
  type    = map(string)
  default = {}
}