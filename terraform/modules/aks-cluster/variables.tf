variable "resource_group_name" {
  type = string
  description = "resource group name"
}
variable "resource_group_location" {
  type = string
  description = "location of resource"
}
variable "cluster_name" {
  type = string
  description = "kubernetes cluster name"
}
variable "private_cluster_enabled" {
  description = "Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to false. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}
variable "kubernetes_version" {
  type = string
  description = "kubernetes version"
}
variable "default_node_pool_vm_size" {
  description = "Specifies the vm size of the default node pool"
  default     = "Standard_DS2_v2"
  type        = string
}
variable "default_node_pool_availability_zones" {
  description = "Specifies the availability zones of the default node pool"
  default     = ["1", "2", "3"]
  type        = list(string)
}
variable "network_docker_bridge_cidr" {
  description = "Specifies the Docker bridge CIDR"
  default     = "172.17.0.1/16"
  type        = string
}
variable "network_dns_service_ip" {
  description = "Specifies the DNS service IP"
  default     = "10.1.0.10"
  type        = string
}

variable "network_service_cidr" {
  description = "Specifies the service CIDR"
  default     = "10.1.0.0/16" 
  type        = string
}

variable "network_plugin" {
  description = "Specifies the network plugin of the AKS cluster"
  default     = "azure"
  type        = string //kubnet -//CNI-azure 
}

variable "network_policy" {
  description = "Specifies the network policy of the AKS cluster"
  default     = "azure"
  type        = string //azure or calico
}
variable "default_node_pool_name" {
  description = "Specifies the name of the default node pool"
  default     = "agentpool"
  type        = string
}

variable "default_node_pool_subnet_name" {
  description = "Specifies the name of the subnet that hosts the default node pool"
  default     = "SystemSubnet"
  type        = string
}
variable "default_node_pool_subnet_address_prefix" {
  description = "Specifies the address prefix of the subnet that hosts the default node pool"
  default     = ["10.0.0.0/20"]
  type        = list(string)
}
variable "node_count" {
  type = number
  description = "Number of AKS worker nodes"
  default = 2
}
variable "dns_prefix" {
  type = string
  default = "platform-eng-test"
}
variable "vnet_id" {
  type = string
  description = "vnet ID from the networking module"
}
variable "vnet_aks_subnet_id" {
  type = string
  description = "Virtual network aks subnet ID from the networking module"
}
variable "appgw_subnet_id" {
  type = string
  description = "appgw subnet ID from the networking module"
}
variable "appgw_id" {
  type = string
  description = "appgw ID from the appgw module"
}
variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID from monitoring"
}
variable "admin_username" {
  description = "(Required) Specifies the Admin Username for the AKS cluster worker nodes. Changing this forces a new resource to be created."
  type        = string
  default     = "azadmin"
}

# variable "ssh_public_key" {
#   description = "(Required) Specifies the SSH public key used to access the cluster. Changing this forces a new resource to be created."
#   type        = string
#   default     = "ssh_pub_keys/azureuser.pub"
# }