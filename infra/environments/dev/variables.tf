variable "subscription_id" {
  type = string
}

variable "prefijo" {
  type    = string
  default = "opsdashboard"
}

variable "ambiente" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "westus"
}

variable "db_admin_password" {
  type      = string
  sensitive = true
}