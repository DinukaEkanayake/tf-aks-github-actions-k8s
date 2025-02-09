resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "aks-cluster" {
  source = "./modules/aks-cluster"
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  cluster_name = var.cluster_name
  node_count = var.node_count
  kubernetes_version = var.kubernetes_version
  vnet_subnet_id = module.networking.vnet_subnet_id
  log_analytics_workspace_id  = module.monitoring.log_analytics_workspace_id #Passes a Log Analytics workspace from the monitoring module for AKS logging.

  depends_on = [ 
    azurerm_resource_group.rg
   ]
}
#Stores Docker container images used by AKS
module "acr" {
  source = "./modules/acr"
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  registry_name = var.registry_name

  depends_on = [ 
    azurerm_resource_group.rg
   ]
}

module "networking" {
  source = "./modules/networking"
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location

  depends_on = [ 
    azurerm_resource_group.rg
   ]
}
#Calls the Storage module (./modules/storage) to create an Azure Storage Account
module "storage" {
  source = "./modules/storage"
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  
  depends_on = [ 
    azurerm_resource_group.rg
   ]
}
#deploy Log Analytics Workspace for AKS monitoring and Azure Monitor integration for performance tracking
module "monitoring" {
  source = "./modules/monitoring"
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location

  depends_on = [ 
    azurerm_resource_group.rg
   ]
}

# Grants permission to AKS to pull container images from ACR
resource "azurerm_role_assignment" "aks_acr" {
  principal_id         = module.aks-cluster.aks_principal_id #Retrieves the AKS service principal ID from the AKS module
  role_definition_name = "AcrPull"
  scope                = module.acr.acr_id
  skip_service_principal_aad_check = true #Bypasses an AAD (Azure Active Directory) check to avoid issues when using managed identities.
}

