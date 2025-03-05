resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.appgw_name}-pip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = var.pip_allocation_method
  sku                 = var.pip_sku
}

# Create local variables for Application Gateway
locals {
  gateway_ip_configuration_name  = "${var.appgw_name}-configuration"
  frontend_port_name             = "${var.appgw_name}-feport"
  frontend_ip_configuration_name = "${var.appgw_name}-feip"
  backend_address_pool_name      = "${var.appgw_name}-beap"
  backend_http_settings_name     = "${var.appgw_name}-be-http"
  http_listener_name             = "${var.appgw_name}-http-listner"
  request_routing_rule_name      = "${var.appgw_name}-rqrt-rule"
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.appgw_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  sku {
  name = var.appgtw_sku_size
  tier = var.appgtw_sku_tier
  capacity = var.appgtw_sku_capacity
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration_name
    subnet_id = var.vnet_appgw_subnet_id
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    cookie_based_affinity  = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_settings_name
    priority                   = 1
  }

  depends_on = [
    azurerm_public_ip.appgw_pip
  ]
}

