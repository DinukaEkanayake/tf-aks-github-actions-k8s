#Retrieves the kubeconfig needed to connect to the AKS cluster. contains credentials for kubectl to interact with the cluster.
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
  sensitive = true
}
output "aks-cluster_id" {
  value = azurerm_kubernetes_cluster.aks-cluster.id
}
#Azure AD Principal ID represents the Managed Identity used by AKS to access other Azure services securely.
output "aks_principal_id" {
  value = azurerm_kubernetes_cluster.aks-cluster.kubelet_identity[0].object_id
}
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks-cluster.name
}
output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.aks-cluster.node_resource_group
}

# Required to set IAM role on appgw subnet.
output "aks_uai_appgw_object_id" { 
  value = azurerm_kubernetes_cluster.aks-cluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id 
}