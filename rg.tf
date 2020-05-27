resource "azurerm_resource_group" "rg" {
  name     = "${var.deployment_prefix}-rg"
  location =  var.deployment_location


  tags = {
    environment = "${var.environment_tag}"
  }
}