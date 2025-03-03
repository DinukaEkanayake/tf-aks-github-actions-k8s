resource "azurerm_kubernetes_cluster_node_pool" "linuxnode" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-cluster.id
  name = "agentpool"
  mode = "User"
  vm_size    = "Standard_DS2_v2"
  vnet_subnet_id = var.vnet_aks_subnet_id
  node_count = 1
#   auto_scaling_enabled = true
#   max_count = 1
#   min_count = 1
}