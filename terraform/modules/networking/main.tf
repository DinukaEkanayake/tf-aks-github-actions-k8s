resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location = var.resource_group_location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name =  var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "appgw_subnet" {
  name                 = var.appgw_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create NSG for AKS Subnet
resource "azurerm_network_security_group" "aks_nsg" {
  name                = "aks-subnet-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  # Allow inbound traffic from AppGW Subnet
  security_rule {
    name                       = "Allow-AppGW-to-AKS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = azurerm_subnet.appgw_subnet.address_prefixes[0]
    source_port_range           = "*" 
    destination_address_prefix  = azurerm_subnet.aks_subnet.address_prefixes[0]
    destination_port_ranges     = ["80", "443"]
  }

  security_rule {
    name                        = "AllowAKStoAppGw"
    priority                    = 1002
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_address_prefix       = azurerm_subnet.aks_subnet.address_prefixes[0]
    source_port_range           = "*"
    destination_address_prefix  = azurerm_subnet.appgw_subnet.address_prefixes[0]
    destination_port_ranges     = ["65200-65535"]
  }


  # Allow Kubernetes API Server (Required for AKS)
  security_rule {
    name                       = "Allow-Kube-API"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow SSH from trusted IPs
  security_rule {
    name                        = "AllowSSH"
    priority                    = 1004
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "10.0.0.0/16"  # Replace with your IP
    destination_address_prefix  = "*"
  }
}

# Associate NSG with AKS Subnet
resource "azurerm_subnet_network_security_group_association" "aks_nsg_assoc" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id
}

# Create NSG for AppGW Subnet
resource "azurerm_network_security_group" "appgw_nsg" {
  name                = "appgw-subnet-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
     name                        = "AllowGatewayManagerInbound"
     description                 = "Allow Azure application GatewayManager on management ports"
     priority                    = 2510
     direction                   = "Inbound"
     access                      = "Allow"
     protocol                    = "Tcp"
     source_port_range           = "*"
     source_address_prefix       = "GatewayManager"
     destination_port_range      = "65200-65535"
     destination_address_prefix  = "*"
   }

  # Allow outbound traffic to AKS Subnet
  security_rule {
    name                       = "Allow-AppGW-Outbound-to-AKS"
    priority                   = 1005
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.aks_subnet.address_prefixes[0]
  }
}

# Associate NSG with AppGW Subnet
resource "azurerm_subnet_network_security_group_association" "appgw_nsg_assoc" {
  subnet_id                 = azurerm_subnet.appgw_subnet.id
  network_security_group_id = azurerm_network_security_group.appgw_nsg.id
}