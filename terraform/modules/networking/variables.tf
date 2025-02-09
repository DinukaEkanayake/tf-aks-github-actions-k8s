variable "resource_group_name" {
  type = string
  description = "resource group name"
}
variable "resource_group_location" {
  type = string
  description = "location of resource"
}
variable "vnet_name" { 
  default = "aks-vnet"
}
variable "subnet_name" { 
  default = "aks-subnet" 
}
variable "nsg_name" {
  default = "aks-nsg"
}