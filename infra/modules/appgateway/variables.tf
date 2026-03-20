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

variable "subnet_appgw_id" {
  description = "ID de la subnet dedicada para App Gateway"
  type        = string
}

variable "sku_name" {
  description = "Nombre del SKU: Standard_v2 o WAF_v2"
  type        = string
  default     = "Standard_v2"
}

variable "sku_tier" {
  description = "Tier del SKU: Standard_v2 (dev/staging) o WAF_v2 (prod)"
  type        = string
  default     = "Standard_v2"

  validation {
    condition     = contains(["Standard_v2", "WAF_v2"], var.sku_tier)
    error_message = "SKU tier debe ser Standard_v2 o WAF_v2."
  }
}

variable "capacity" {
  description = "Número de instancias. dev: 1 | prod: 2"
  type        = number
  default     = 1
}

variable "tags" {
  type    = map(string)
  default = {}
}