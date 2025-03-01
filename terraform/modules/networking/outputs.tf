output "vnet_aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}
output "vnet_appgw_subnet_id" {
  value = azurerm_subnet.appgw_subnet.id
}