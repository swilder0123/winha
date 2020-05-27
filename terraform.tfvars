deployment_location      = "westus"
deployment_prefix        = "winha"
node_count               = 3
ad_domain_name           = "contosopower.net"
ad_domain_dn             = "dc=contosopower,dc=net"
ad_server_ou_path        = "OU=Servers,OU=HQ,DC=contosopower,DC=net"
ad_domain_short_name     = "contosopower"
ad_domain_key_vault_name = "cpw-hubkv-01"
ad_domain_key_vault_rg   = "cpw-westhub-rg"
ad_dns_host_address      = "172.22.0.4"
vnet_address_space       = ["10.10.40.0/22", "192.168.20.0/24"]
vnet_dns_servers         = ["172.22.0.4"]
vnet_peer_name           = "cpw-westhub-vnet"
vnet_peer_rg             = "cpw-westhub-rg"
public_subnet_prefix     = "10.10.40.0/24"
private_subnet_prefix    = "192.168.20.0/24"
environment_tag          = "Production"
my_client_ip             = "45.28.141.237"
