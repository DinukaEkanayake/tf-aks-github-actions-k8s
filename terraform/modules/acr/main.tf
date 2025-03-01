resource "azurerm_container_registry" "acr" {
  name = var.registry_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  sku = "Standard"
  admin_enabled = false //no need username,password to login to acr
}