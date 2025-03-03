resource "azurerm_user_assigned_identity" "aks-access" {
  name = "aks-access"
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name = var.cluster_name
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  kubernetes_version = var.kubernetes_version
  dns_prefix          = var.dns_prefix #Used for creating the default DNS name of the Kubernetes API server.
  sku_tier = "Free"

  default_node_pool {
    name       = "nodepool"
    node_count =  var.node_count
    vm_size    = "Standard_DS2_v2" #2 vCPUs, 7GB RAM
    zones = [ 3 ] 
    # type = "VirtualMachineScaleSets" #Uses VMSS (Virtual Machine Scale Sets) for auto-scaling.
    # auto_scaling_enabled = true
    vnet_subnet_id = var.vnet_aks_subnet_id
    # max_count = 1
    # min_count = 1
  }
  
  #allows AKS cluster to securely interact with Azure resources without needing service principal credentials.
  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.aks-access.id ]
  }

  # Enable AGIC with existing App Gateway
  ingress_application_gateway {
    gateway_id = var.appgw_id
  }

  #restricting access to kubectl commands
  role_based_access_control_enabled = true

  #Configure Azure CNI Plugin - Allows Kubernetes pods to get IPs from the VNet
  network_profile {
    network_plugin = "azure" #Uses the Azure CNI (Container Network Interface) for better integration with Azure VNet.
    load_balancer_sku = "standard" #Uses the Standard Load Balancer for high availability
    service_cidr        = "10.1.0.0/16" # Updated to avoid conflict with subnet (10.0.1.0/24)
    dns_service_ip      = "10.1.0.10" # Must be within service_cidr range
  }

  #link to the Log Analytics Workspace for log collection and monitoring
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = {
    environment = "dev"
  }

}