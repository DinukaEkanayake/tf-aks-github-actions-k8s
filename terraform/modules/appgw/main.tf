resource "azurerm_public_ip" "appgw_pip" {
  name                = "${var.appgw_name}-pip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.appgw_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  sku {
  name = "Standard_v2"
  tier = "Standard_v2"
  capacity = 1
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.vnet_appgw_subnet_id
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  frontend_port {
    name = "httpPort"
    port = 443
  }

  backend_address_pool {
    name = "appGatewayBackendPool"
  }

  backend_http_settings {
    name                  = "backend-http-setting"
    cookie_based_affinity  = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "httpListener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "httpRule"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = "httpListener"
    backend_address_pool_name  = "appGatewayBackendPool"
    backend_http_settings_name = "backend-http-setting"
  }

  depends_on = [
    var.resource_group_name,
    var.vnet_appgw_subnet_id,
    azurerm_public_ip.appgw_pip
  ]
}

