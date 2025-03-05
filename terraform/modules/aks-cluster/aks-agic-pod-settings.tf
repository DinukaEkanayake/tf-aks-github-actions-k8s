data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "pod_identity_appgw" {
  name                = "ingressapplicationgateway-${azurerm_kubernetes_cluster.aks-cluster.name}"
  resource_group_name = "MC_${data.azurerm_resource_group.rg.name}_${azurerm_kubernetes_cluster.aks-cluster.name}_${var.resource_group_location}"
  depends_on = [
    data.azurerm_resource_group.rg,
    azurerm_kubernetes_cluster.aks-cluster,
  ]
}

resource "azurerm_role_assignment" "identity_appgw_contributor_ra" {
  scope                = var.appgw_id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.pod_identity_appgw.principal_id
  skip_service_principal_aad_check = true
  depends_on = [
    azurerm_kubernetes_cluster.aks-cluster,
  ]
}

# Give the identity Reader access to the Application Gateway resource group.
resource "azurerm_role_assignment" "identity_appgw_reader_ra" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = data.azurerm_user_assigned_identity.pod_identity_appgw.principal_id
  skip_service_principal_aad_check = true
  
  depends_on = [
    data.azurerm_resource_group.rg,
    azurerm_kubernetes_cluster.aks-cluster
  ]
}

resource "azurerm_role_assignment" "identity_appgw_network_contributor_ra" {
  scope                = var.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = data.azurerm_user_assigned_identity.pod_identity_appgw.principal_id
  skip_service_principal_aad_check = true
  
  depends_on = [
    azurerm_kubernetes_cluster.aks-cluster
  ]
}