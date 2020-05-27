# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.0.0"
   features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_subscription" "current" {

}

# we need to fetch a domain credential from a pre-existing keyvault, here it is:
data "azurerm_key_vault" "domain_kv" {
  name                = var.ad_domain_key_vault_name
  resource_group_name = var.ad_domain_key_vault_rg
}

# the domain join user (standard user access) must have domain join access
data "azurerm_key_vault_secret" "domain_join" {
    name                  = var.domain_join_user
    key_vault_id          = data.azurerm_key_vault.domain_kv.id
}