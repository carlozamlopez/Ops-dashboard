output "aks_id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "kubelet_identity_object_id" {
  description = "Object ID del kubelet — usado para asignar AcrPull en ACR"
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

output "kube_config" {
  description = "Configuración para conectar kubectl al cluster"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}