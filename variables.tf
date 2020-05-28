
variable "deployment_prefix" {
  description   = "Base name of the deployment...used to build other object names (required)"
  type          = string
}

variable "environment_tag" {
  description   = "A tag to deploy to all resources to designate environment (optional)"
  type          = string
}

variable "deployment_location" {
  description   = "Azure region for this deployment (required)"
  type          = string
}

variable "node_count" {
  description   = "Number of cluster nodes to deploy (default: 2)"
  type          = number
  default       = 2
}

variable "node_size" {
  description  = "Size of the machine to deploy for cluster nodes (default: 'Standard_DS2_v2')"
  default      = "Standard_B2ms"
}

variable "local_admin_user" {
  description = "Name of the local admin account"
  default     = "nodeadmin"
}

variable "ad_domain_name" {
  description = "Active Directory domain for the cluster (required)"
  type        = string
}

variable "ad_domain_short_name" {
  description = "Active Directory single-label domain name"
}

variable "ad_domain_dn" {
  description = "Active Directory LDAP-style"
}

variable "ad_server_ou_path" {
  description = "Active Directory OU/container for server machine accounts."
  type        = string
}

variable "ad_dns_host_address" {
  description  = "Primary DNS host address"
  type         = string
}

variable "ad_domain_key_vault_name" { 
  description = "Azure Key Vault from which to fetch the domain join credential"
}

variable "ad_domain_key_vault_rg" {
  description = "Resource group for the domain credential key vault"
}

variable "domain_admin_user" {
  description = "Account used to create and admin domain controllers"
  default     = "domainadmin"
}

variable "domain_join_user" {
  description = "Name of the user to authenticate with the domain"
  default     = "joinadmin"
}

# Not yet implemented, leave as false
variable "vnet_use_existing" {
  description = "Use existing vNet or create a new one?"
  default     = false
}

# Used only for new vNets
variable "vnet_address_space" {
  type = list
  description = "Address space(s) for the deployment vnet"
}

variable "vnet_dns_servers" {
  type = list
  description = "DNS server(s) for this deployment"
}

variable "vnet_peer_name" {
  type = string
  description = "Partner vNet to peer with (e.g., for domain controller access)."
}

variable "vnet_peer_rg" {
  type = string
  description = "Name of the peering vNet's resource group"
}

variable "private_subnet_name" {
  description = "ID of the cluster private subnet"
  default     = "private"
}

variable "private_subnet_prefix" {
  description = "Prefix for the private subnet"
}

variable "public_subnet_name" {
  description = "ID of the public-facing subnet"
  default     = "public"
}

variable "public_subnet_prefix" {
  description   = "Prefix for the public subnet"
}

variable "vm_size" {
  description   = "Size of the machine to deploy"
  default       = "Standard_DS2_v2"
}

variable "os_image" {
  description = "Image information for the instances"
  type = map
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

variable "as_platform_update_domain_count" {
  description = "Update domain configuration (maximum)"
  default     = 5
}

variable "as_platform_fault_domain_count" {
  description = "Number of fault domains for the deployment location (maximum)"
  type = map
  default = {
    westus            = 3
    westus2           = 2
    eastus            = 3
    eastus2           = 3
    westeurope        = 3
    northeurope       = 3
    southcentralus    = 3
    northcentralus    = 3
    westcentralus     = 2
    canadacentral     = 3
    canadaeast        = 2
    uksouth           = 2
    ukwest            = 2
    eastasia          = 2
    southeastasia     = 2
    japaneast         = 2
    japanwest         = 2
    southindia        = 2
    centralindia      = 2
    eastindia         = 2
    brazilsouth       = 2
  }
}

variable "extension_custom_script" {
  description = "Should a custom script extension be run on all servers (default: no)"
  default     = false
}

variable "extension_custom_script_fileuri" {
  description = "Location for the configuration scripts needed for the cluster"
  default = "https://raw.githubusercontent.com/swilder0123/winha/master/config"
}

variable "extensions_custom_script_names" {
  description = "File URIs to be consumed by the custom script extension (optional)"
  type = map
  default     = {
    "nodesetup"   =  "nodesetup.ps1"
    "jbsetup"     =  "jbsetup.ps1"
  }
}

variable "extensions_custom_command" {
  description = "Command for the custom script extension to run (optional)"
  default     = ""
}

variable "os_disk_class" {
  description = "Class of disk storage for the VM (default: Standard_SSD)"
  default = "Standard_SSD"
}
variable "os_disk_size" {
  description = "The size of the OS disk (default: 128GB)"
  default     = 128
}

variable "data_disk_size" {
  description = "The size of the data disk (default: 30GB)"
  default     = 30
}

variable "managed_disk_sizes" {
  description = "The sizes of the optional managed data disks (default: 32GB)"
  default     = ["32"]
}

variable "managed_disk_type" {
  description = "Disk storage type. (default: Standard_LRS)"
  default     = "Standard_LRS"
}

variable "my_client_ip" {
  description = "Client IP to allow admin access through Key Vault firewall"
}
