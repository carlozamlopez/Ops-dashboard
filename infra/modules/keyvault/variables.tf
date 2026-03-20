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

variable "aks_principal_id" {
  description = "Object ID del managed identity de AKS para leer secretos"
  type        = string
}

variable "secrets" {
  description = "Mapa de secretos a crear en Key Vault"
  type        = map(string)
  sensitive   = true
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}