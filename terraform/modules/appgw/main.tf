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
  capacity = 2
}

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.vnet_appgw_subnet_id
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  frontend_port {
    name = "frontend-port"
    port = 80
  }

  backend_address_pool {
    name = "backend-pool"
  }

  backend_http_settings {
    name                  = "backend-http-setting"
    cookie_based_affinity  = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "http-rule"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "backend-http-setting"
  }
  
}

