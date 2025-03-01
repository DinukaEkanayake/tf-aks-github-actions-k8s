output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "acr_login_server" {
  value = module.acr.acr_login_server
}
output "acr_username" {
  value = module.acr.acr_username
}

output "acr_password" {
  value = module.acr.acr_password
  sensitive = true
}

output "aks_principal_id" {
  value = module.aks-cluster.aks_principal_id
}

# Required to set IAM role on appgw subnet.
output "aks_uai_appgw_object_id" { 
  value = module.aks-cluster.aks_uai_appgw_object_id
}