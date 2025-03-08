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
  value     = module.acr.acr_password
  sensitive = true
}

output "kubelet_identity_object_id" {
  value = module.aks-cluster.kubelet_identity_object_id
}

# Required to set IAM role on appgw subnet.
output "aks_uai_appgw_object_id" {
  value = module.aks-cluster.aks_uai_appgw_object_id #a9f2102f-ab80-47d2-b0ee-dfa8b6d588f3
}