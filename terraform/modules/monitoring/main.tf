resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "aks-log-workspace"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
