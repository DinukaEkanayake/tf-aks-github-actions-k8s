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
variable "kubernetes_version" {
  type = string
  description = "kubernetes version"
}
variable "node_count" {
  type = number
  description = "Number of AKS worker nodes"
}
variable "dns_prefix" {
  type = string
  default = "platform-eng-test"
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
