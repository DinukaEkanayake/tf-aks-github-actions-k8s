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
  value = azurerm_kubernetes_cluster.aks-cluster.identity[0].principal_id
}
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks-cluster.name
}
