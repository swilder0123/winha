# We need to 'unique-ify the storage account name, we will do so by adding a random 5 character string consisting solely of numbers
resource "random_string" "randstr" {
  length = 5
  number = true
  special = false
  lower = false
  upper = false
  }

resource "azurerm_storage_account" "blobacct" {
  name                     = "${var.deployment_prefix}${random_string.randstr.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}