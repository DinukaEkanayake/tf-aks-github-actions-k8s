variable "resource_group_name" {
  type = string
  description = "resource group name"
}
variable "location" {
  type = string
  default = "eastus"
  description = "location of resource"
}
variable "cluster_name" {
  type = string
  description = "kubernetes cluster name"
}
variable "kubernetes_version" {
  type = string
  description = "Specifies the version of Kubernetes to be used for the AKS cluster"
}
variable "node_count" {
  type = number
  description = "number of worker nodes in the AKS cluste"
}
variable "dns_prefix" {
  type = string
  default = "platform-eng-test"
  description = "DNS prefix used for the Kubernetes API server endpoint.This is necessary to access the Kubernetes API and manage cluster resources"
}
variable "registry_name" {
  type = string
  description = "cAzure Container Registry (ACR) for storing container images"
}
variable "vnet_name" { 
  default = "aks-vnet"
  description = "name of the Azure Virtual Network (VNet) that AKS will use"
}
variable "subnet_name" { 
  default = "aks-subnet" 
  description = "name of the subnet within the Virtual Network (VNet) where the AKS nodes will deploy.Ensures AKS nodes have dedicated IP addresses"
}