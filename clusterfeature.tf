variable "cluster_full_install" {
  description = "Command block to install the cluster nodes"
  default = "@ {Enable-WindowsOptionalFeature -online -FeatureName FailoverCluster-FullServer}"
}

variable "cluster_tools_install" {
  description = "Command block to install the jumpbox admin tools"
  default = "\"commandToExecute\": \"powershell.exe -command \\\"@ {Enable-WindowsOptionalFeature -online -FeatureName FailoverCluster-AdminPak}\\\"\""
}

resource "azurerm_virtual_machine_extension" "nodesetup" {
  count                 = var.node_count
  name                  = "${var.deployment_prefix}-cfext-${count.index}"
  virtual_machine_id   = azurerm_windows_virtual_machine.node["${count.index}"].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  # Enable-WindowsOptionalFeature -online -FeatureName FailoverCluster-FullServer
  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -command \\\"${var.cluster_full_install}\\\""
    }
SETTINGS
  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_machine_extension" "jbsetup" {
  name                  = "${var.deployment_prefix}-cfext-jb"
  virtual_machine_id   = azurerm_windows_virtual_machine.jumpbox.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  # Enable-WindowsOptionalFeature -online -FeatureName FailoverCluster-FullServer
  settings = {"${var.cluster_tools_install}"}

  tags = {
    environment = "Production"
  }
}


