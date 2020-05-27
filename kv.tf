
data "azurerm_client_config" "current" {}

resource "random_password" "ladmin" {
    length    =    16
    special   =    true
    min_upper =    1
    min_lower =    1
    override_special = "_%&*!"
}

resource "random_password" "dadmin" {
    length    =    16
    special   =    true
    min_upper =    1
    min_lower =    1
    override_special = "_%&*!"
}

resource "random_password" "djoin" {
    length    =    16
    special   =    true
    min_upper =    1
    min_lower =    1
    override_special = "_%&*!"
}

resource "azurerm_key_vault" "kv" {
  name                            = "${var.deployment_prefix}-kv"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled             = false
  purge_protection_enabled        = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get","list"
    ]

    secret_permissions = [
      "get","list","set","delete"
    ]

    storage_permissions = [
      "get","list","set"
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = ["${var.my_client_ip}"]
  }

  tags = {
    environment = "Testing"
  }
}

resource "azurerm_key_vault_secret" "local_admin_user" {
    name                    = var.local_admin_user
    value                   = random_password.ladmin.result
    key_vault_id            = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "domain_admin_user" {
    name                    = var.domain_admin_user
    value                   = random_password.dadmin.result
    key_vault_id            = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "domain_join_user" {
    name                    = var.domain_join_user
    value                   = random_password.djoin.result
    key_vault_id            = azurerm_key_vault.kv.id
}
