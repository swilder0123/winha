resource "azurerm_public_ip" "jumpbox_pip" {
    name                   = "${var.deployment_prefix}-jumpbox-pip"
    location               = azurerm_resource_group.rg.location
    resource_group_name    = azurerm_resource_group.rg.name
    allocation_method      = "Dynamic"
    domain_name_label      = "${var.deployment_prefix}-jumpbox"
}

resource "azurerm_network_interface" "nic_jb" {
  name                            = "${var.deployment_prefix}-nic-jumpbox"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.deployment_prefix}-ipcfg-jumpbox"
    subnet_id                     =  azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumpbox_pip.id
  }
}

resource "azurerm_network_security_group" "jumpbox_rdp" {
    name                = "${var.deployment_prefix}-nsg-jumpbox"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
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
  network_security_group_name = azurerm_network_security_group.jumpbox_rdp.name
}

resource "azurerm_network_interface_security_group_association" "jumpbox_nsg_assoc" {
    network_interface_id       = azurerm_network_interface.nic_jb.id
    network_security_group_id  = azurerm_network_security_group.jumpbox_rdp.id
}

resource "azurerm_windows_virtual_machine" "jumpbox" {
  name                      = "${var.deployment_prefix}-jumpbox"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  size                      = var.node_size
  admin_username            = var.local_admin_user
  admin_password            = azurerm_key_vault_secret.local_admin_user.value
  network_interface_ids     = [
        azurerm_network_interface.nic_jb.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
    storage_account_uri  = azurerm_storage_account.blobacct.primary_blob_endpoint
  }

  source_image_reference {
    publisher = var.os_image.publisher
    offer     = var.os_image.offer
    sku       = var.os_image.sku
    version   = var.os_image.version
  }
}


