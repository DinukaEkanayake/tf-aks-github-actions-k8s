resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name = var.cluster_name
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  kubernetes_version = var.kubernetes_version
  dns_prefix          = var.dns_prefix #Used for creating the default DNS name of the Kubernetes API server.

  default_node_pool {
    name       = "agentpool"
    node_count =  var.node_count
    vm_size    = "Standard_DS2_v2" #2 vCPUs, 7GB RAM
    zones = [ 3 ] 
    type = "VirtualMachineScaleSets" #Uses VMSS (Virtual Machine Scale Sets) for auto-scaling.
    vnet_subnet_id = var.vnet_aks_subnet_id

  }
  
  #allows AKS cluster to securely interact with Azure resources without needing service principal credentials.
  identity {
    type = "SystemAssigned"
  }

  # Enable AGIC with existing App Gateway
  ingress_application_gateway {
    subnet_id = var.appgw_subnet_id
  }

  #restricting access to kubectl commands
  role_based_access_control_enabled = true

  #Configures the networking settings for AKS
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