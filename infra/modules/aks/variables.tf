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

variable "subnet_aks_id" {
  description = "ID de la subnet AKS del módulo networking"
  type        = string
}

variable "log_analytics_id" {
  description = "ID del Log Analytics Workspace para monitoreo"
  type        = string
}

variable "acr_id" {
  description = "ID del ACR para asignar rol AcrPull al kubelet"
  type        = string
}

variable "app_gateway_id" {
  description = "ID del App Gateway para AGIC"
  type        = string
}

variable "node_count" {
  description = "Número de nodos. dev: 1 | staging: 2 | prod: 3"
  type        = number
  default     = 1
}

variable "node_vm_sku" {
  description = "SKU de los nodos. Proyecto usa Standard_DC2s_v3"
  type        = string
  default     = "Standard_DC2s_v3"
}

variable "availability_zones" {
  description = "Zonas de disponibilidad. dev: [1] | prod: [1,2,3]"
  type        = list(string)
  default     = ["1"]
}

variable "tags" {
  type    = map(string)
  default = {}
}