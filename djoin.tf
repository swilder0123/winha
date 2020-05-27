
resource "azurerm_virtual_machine_extension" "djoin" {
    count                 = var.node_count
    name                  = "${var.deployment_prefix}-adext-${count.index}"
    virtual_machine_id    = azurerm_windows_virtual_machine.node["${count.index}"].id
    publisher             = "Microsoft.Compute"
    type                  = "JsonADDomainExtension"
    type_handler_version  = "1.3"
    # What the settings mean: https://docs.microsoft.com/en-us/windows/desktop/api/lmjoin/nf-lmjoin-netjoindomain
settings = <<SETTINGS
{
"Name": "${var.ad_domain_name}",
"OUPath": "${var.ad_server_ou_path}",
"User": "${var.ad_domain_short_name}\\${var.domain_join_user}",
"Restart": "true",
"Options": "3"
}
SETTINGS
protected_settings = <<PROTECTED_SETTINGS
{
"Password": "${data.azurerm_key_vault_secret.domain_join.value}"
}
PROTECTED_SETTINGS
}

# Jumpbox domain join is handled separately
resource "azurerm_virtual_machine_extension" "djoin-jb" {
    name                  = "${var.deployment_prefix}-jumpbox"
    virtual_machine_id    = azurerm_windows_virtual_machine.jumpbox.id
    publisher             = "Microsoft.Compute"
    type                  = "JsonADDomainExtension"
    type_handler_version  = "1.3"
    # What the settings mean: https://docs.microsoft.com/en-us/windows/desktop/api/lmjoin/nf-lmjoin-netjoindomain
settings = <<SETTINGS
{
"Name": "${var.ad_domain_name}",
"OUPath": "${var.ad_server_ou_path}",
"User": "${var.ad_domain_short_name}\\${var.domain_join_user}",
"Restart": "true",
"Options": "3"
}
SETTINGS
protected_settings = <<PROTECTED_SETTINGS
{
"Password": "${data.azurerm_key_vault_secret.domain_join.value}"
}
PROTECTED_SETTINGS
}
