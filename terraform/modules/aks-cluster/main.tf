# Create User Assigned Identity used in AKS
# resource "azurerm_user_assigned_identity" "aks_identity" {
#   resource_group_name = var.resource_group_name
#   location            = var.resource_group_location
#   name = "${var.cluster_name}Identity"

# }
resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name = var.cluster_name
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  kubernetes_version = var.kubernetes_version
  dns_prefix          = var.dns_prefix #Used for creating the default DNS name of the Kubernetes API server.
  private_cluster_enabled = var.private_cluster_enabled
  sku_tier = "Free"

  # linux_profile {
  #   admin_username = var.admin_username

  #   ssh_key {
  #     key_data = file("${var.ssh_public_key}")
  #   }
  # }

  default_node_pool {
    name       = var.default_node_pool_name
    node_count =  var.node_count
    vm_size    = var.default_node_pool_vm_size
    zones = var.default_node_pool_availability_zones
    type = "VirtualMachineScaleSets" #Uses VMSS (Virtual Machine Scale Sets) for auto-scaling.
    # auto_scaling_enabled = true
    vnet_subnet_id = var.vnet_aks_subnet_id
    # max_count = 1
    # min_count = 1
  }
  
  #allows AKS cluster to securely interact with Azure resources without needing service principal credentials.
  identity {
    type = "SystemAssigned"
    # user_assigned_identity_id = azurerm_user_assigned_identity.aks_identity.id
  }

  # Enable AGIC with existing App Gateway
  ingress_application_gateway {
    gateway_id = var.appgw_id
  }

  #restricting access to kubectl commands
  role_based_access_control_enabled = true

  #Configure Azure CNI Plugin - Allows Kubernetes pods to get IPs from the VNet
  network_profile {
    load_balancer_sku = "standard"  #Uses the Standard Load Balancer for high availability
    network_plugin    = var.network_plugin  #Uses the Azure CNI (Container Network Interface) for better integration with Azure VNet.
    network_policy    = var.network_policy
    service_cidr       = var.network_service_cidr # Updated to avoid conflict with subnet (10.0.1.0/24)
    dns_service_ip     = var.network_dns_service_ip   # Must be within service_cidr range
  }

  #link to the Log Analytics Workspace for log collection and monitoring
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = {
    environment = "dev"
  }

}