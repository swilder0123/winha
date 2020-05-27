locals {
    extension_name       = "cfext"
    node_script          = var.extensions_custom_script_names["nodesetup"]
    jb_script            = var.extensions_custom_script_names["jbsetup"]
    execution_cmd        = "powershell -ExecutionPolicy Unrestricted -File "
    time_stamp           = timestamp()
}

resource "azurerm_virtual_machine_extension" "nodesetup" {
  count                 = var.node_count
  name                  = local.extension_name
  virtual_machine_id    = azurerm_windows_virtual_machine.node["${count.index}"].id
  publisher             = "Microsoft.Compute"
  type                  = "CustomScriptExtension"
  type_handler_version  = "1.9"

  settings = <<SETTINGS
  {
      "fileUris": [
          "@{var.extensions_custom_script_fileuri}/@{local.node_script}"
      ],
      "timeStamp": "${local.time_stamp}"
  }
SETTINGS
  protected_settings = <<PROTECTEDSETTINGS
  {
    "commandToExecute": "${local.execution_cmd} ${local.node_script}"
  }
PROTECTEDSETTINGS

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_virtual_machine_extension" "jbsetup" {
  name                 = local.extension_name
  virtual_machine_id   = azurerm_windows_virtual_machine.jumpbox.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
  {
      "fileUris": [
          "@{var.extensions_custom_script_fileuri}/@{local.jb_script}"
      ],
      "timeStamp": "${local.time_stamp}"
  }
SETTINGS
  protected_settings = <<PROTECTEDSETTINGS
  {
    "commandToExecute": "${local.execution_cmd} ${local.jb_script}"
  }
PROTECTEDSETTINGS

  tags = {
    environment = var.environment_tag
  }
}


