resource "azurerm_network_interface" "nic_jb" {
  name                            = "${var.deployment_prefix}-nic-jumpbox"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.deployment_prefix}-ipcfg-jumpbox"
    subnet_id                     =  azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
  }
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


