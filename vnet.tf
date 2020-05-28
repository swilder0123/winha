resource "azurerm_network_security_group" public_nsg {
    name                = "${var.deployment_prefix}-nsg-public"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "public_nsg_rule" {
  name                        = "Internet_access"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.public_nsg.name
}

resource "azurerm_network_security_rule" "jumpbox_rdp_rule" {
  name                        = "RDP_access"
  priority                    = 201
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.my_client_ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.public_nsg.name
}

resource "azurerm_subnet_network_security_group_association" nsg_assoc {
    subnet_id                  = azurerm_subnet.public.id
    network_security_group_id  = azurerm_network_security_group.public_nsg.id
}

data "azurerm_virtual_network" "peer" {
    name                = var.vnet_peer_name
    resource_group_name = var.vnet_peer_rg
}

resource "azurerm_virtual_network" "vnet" {
    name                = "${var.deployment_prefix}-vnet"
    address_space       = var.vnet_address_space
    location            = azurerm_resource_group.rg.location
    dns_servers         = var.vnet_dns_servers
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "private" {
  name                 = "${azurerm_virtual_network.vnet.name}-subnet-private"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.private_subnet_prefix

}

resource "azurerm_subnet" "public" {
  name                 = "${azurerm_virtual_network.vnet.name}-subnet-public"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = var.public_subnet_prefix
  
}

resource "azurerm_virtual_network_peering" "outbound" {
  name                      = "vnet_to_peer"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.peer.id
}

resource "azurerm_virtual_network_peering" "inbound" {
  name                      = "peer_to_vnet"
  resource_group_name       = var.vnet_peer_rg
  virtual_network_name      = var.vnet_peer_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}