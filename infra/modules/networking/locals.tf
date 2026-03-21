locals {
  tags = merge({
    proyecto   = var.prefijo
    ambiente   = var.ambiente
    managed_by = "terraform"
    owner      = "arch-carlozamlopez"
  }, var.tags_extra)
}