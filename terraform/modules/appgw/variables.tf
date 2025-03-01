variable "resource_group_name" {
  type = string
  description = "resource group name"
}
variable "resource_group_location" {
  type = string
  description = "location of resource"
}
variable "vnet_appgw_subnet_id" {
  type = string
  description = "Virtual network appgw subnet ID from the networking module"
}
variable "appgw_name" {
  default = "my-app-gateway"
}
