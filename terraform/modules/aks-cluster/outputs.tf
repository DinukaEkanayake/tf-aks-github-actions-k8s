#Retrieves the kubeconfig needed to connect to the AKS cluster. contains credentials for kubectl to interact with the cluster.
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
  sensitive = true
}
output "aks-cluster_id" {
  value = azurerm_kubernetes_cluster.aks-cluster.id
}
output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks-cluster.name
}
# output "aks_identity_principal_id" {
#   value       = azurerm_user_assigned_identity.aks_identity.principal_id
#   description = "Specifies the principal id of the managed identity of the AKS cluster."
# }

#Azure AD Principal ID represents the Managed Identity used by AKS to access other Azure services securely.
output "kubelet_identity_object_id" {
  value       = azurerm_kubernetes_cluster.aks-cluster.kubelet_identity.0.object_id
  description = "Specifies the object id of the kubelet identity of the AKS cluster."
}
output "aks_node_resource_group" {
  value       = azurerm_kubernetes_cluster.aks-cluster.node_resource_group
  description = "Specifies the resource id of the auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster."
}

# Required to set IAM role on appgw subnet.
output "aks_uai_appgw_object_id" { 
  value = azurerm_kubernetes_cluster.aks-cluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}