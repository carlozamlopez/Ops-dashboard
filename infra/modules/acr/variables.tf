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

variable "sku" {
    description = "SKU del ACR: Basic, Standard, Premium"
    type = string
    default = "Basic"

    validation {
     condition     = contains(["Basic", "Standard", "Premium"], var.sku)
     error_message = "SKU debe ser Basic, Standard o Premium."
  }
}

variable "aks_principal_id" {
    description = "Object ID del managed identity de AKS para AcrPull"
    type = string  
}

variable "tags" {
  type    = map(string)
  default = {}
}