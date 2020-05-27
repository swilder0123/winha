resource "azurerm_availability_set" "avset" {
  name                         = "${var.deployment_prefix}-avset"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  managed                      = true
  platform_update_domain_count = var.as_platform_update_domain_count
  platform_fault_domain_count  = var.as_platform_fault_domain_count[azurerm_resource_group.rg.location]

  
}
