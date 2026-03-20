
output "resource_group_name" {
    value = azurerm_resource_group.main.name  
}

output "resource_group_location" {
    value = azurerm_resource_group.main.location
}

output "vnet_id" {
    value = azurerm_virtual_network.main.id  
}

output "vnet_name" {
    value = azurerm_virtual_network.main.name
}

output "subnet_aks_id" {
    value = azurerm_subnet.aks.id  
}

output "subnet_appgw_id" {
    value = azurerm_subnet.appgateway.id
}

output "subnet_mysql_id" {
    value = azurerm_subnet.mysql.id  
}

output "subnet_mgmt_id" {
    value = azurerm_subnet.management.id  
}

output "log_analytics_workspace_id" {
    value = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_key" {
    value = azurerm_log_analytics_workspace.main.primary_shared_key
    sensitive = true
}