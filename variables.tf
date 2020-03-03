# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# PREFIX FOR RESOURCE NAMING SCHEME -----------------------------------------------------------------------------------
variable "prefix-vpn-hub" {
  description = "The prefix that will be attached to all hub resources deployed"
  default     = "vpn-hub"
}

variable "prefix-spoke" {
  description = "The prefix that will be attached to all spoke resources deployed"
  default     = "spoke"
}

# CREDENTIALS ---------------------------------------------------------------------------------------------------------
variable "subscription_id" {
  description = "Subscription ID"
  default     = ""
}

variable "tenant_id" {
  description = "Tenant ID"
  default     = ""
}

variable "client_id" {
  description = "Client ID"
  default     = ""
}

variable "client_secret" {
  description = "Client secret password"
  default     = ""
}
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

# REGION LOCATION ---------------------------------------------------------------------------------------------------
variable "location" {
  description = "Geo Region - (No spaces)"
  default     = "centralus"
}

# ---------------------------------------------------------------------------------------------------------------------

# USERNAMES VPN/Windows  ----------------------------------------------------------------------------------------------
variable "vpnserver_username" {
  description = "The username configured for linux"
  default     = "username"
}

variable "vpnserver_password" {
  description = "The password configured for linux"
  default     = "*****"
}

variable "windows_username" {
  description = "The username for windows account"
  default     = "username"
}

variable "windows_password" {
  description = "The password for windows account"
  default     = "****"
}

# ---------------------------------------------------------------------------------------------------------------------

# VM VPN SERVER SETTINGS - SIZE,NIC,KEYS,ETC --------------------------------------------------------------------------
variable "vpnserver_vmsize" {
  description = "Size of the VMs"
  default     = "Standard_B2ms"
}

variable "vpnserver_nic" {
  description = "Network interface vpn server"
  default     = "ifconfig01"
}

variable "lighttpd_template" {
  description = "lighttpd.conf build template"
  default     = "./templates/lighttpd.conf.template"
}

variable "networking_template" {
  description = "networking script template"
  default     = "./templates/networking.sh.template"
}

variable "dh_pem" {
  description = "DH parameters file using the predefined ffdhe4096 group"
  default     = "./templates/dh4096.pem.template"
}

variable "server_conf" {
  description = "VPN Server Configuration template file"
  default     = "./templates/server.conf.template"
}

variable "client_template" {
  description = "VPN client ovpn template file"
  default     = "./templates/client.conf.template"
}

variable "ssh_public_key_file" {
  description = "public ssh key"
  default     = "./ssh_keys/ovpn.pub"
}

variable "ssh_private_key_file" {
  description = "private ssh key"
  default     = "./ssh_keys/ovpn"
}

# Primarily for the server template
variable "VPN_HUB" {
  description = "SUBNET/NETMASK/CIDR for vpn_hub_gateway_subnet Advertise VPN Clients - Push Routing"
  type        = "map"
  default = {
    "SUBNET"  = "10.1.0.0"
    "CIDR"    = "24"
    "NETMASK" = "255.255.255.0"
  }
}

# ---------------------------------------------------------------------------------------------------------------------

### VPN SERVER and Client Configuration file Template Variables #### --------------------------------------------------

## Port to be used by the VPN SERVEF
variable "VPN_PORT" {
  description = "VPN Server Port"
  default     = "1194"
}

## PROTOCOL FOR VPN SERVER UDP/TCP
variable "VPN_PROTOCOL" {
  description = "Protocol for VPN Server server.conf"
  default     = "udp"
}

## Virtual network created by the OpenVPN server. (REQUIRED)
#Client would get a virtual private ip from this range(DHCP setting).
variable "VPN_CLIENT" {
  description = "SUBNET/NETMASK/CIDR for vpn_hub_gateway_subnet Advertise VPN Clients - Push Routing"
  type        = "map"
  default = {
    "SUBNET"  = "10.8.0.0"
    "CIDR"    = "24"
    "NETMASK" = "255.255.255.0"
  }
}

# VPN SERVER Compression Algorithm
variable "VPN_COMPRESSION" {
  description = "VPN compression setting - lzo, lz4 or blank"
  default     = "compress lz4"
}

# VPN SERVER DNS1 OPTION - dhcp-option
variable "VPN_DNS1" {
  description = "First Primary DNS"
  default     = "10.1.0.36"
}

# VPN SERVER DNS1 OPTION - dhcp-option
variable "VPN_DNS2" {
  description = "Secondary DNS"
  default     = "10.1.0.38"
}

# VPN SERVER DNS1 OPTION - dhcp-option
variable "VPN_PRIVATE_IP" {
  description = "VPN SERVER Static Private IP Address"
  default     = "10.1.0.18"
}

# DOMAIN - dhcp-option
variable "DOMAIN" {
  description = "VPN Server Domain"
  type        = "map"
  default = {
    "VPNSERVER" = "vpnhostname01"
    "LOCATION"  = "centralus"
    "ZONE"      = "cloudapp.azure.com"
  }
}

# VM DX Windows Desktop 10  SETTINGS - SIZE,NIC,KEYS,ETC --------------------------------------------------------------------------
variable "dx_windows10_vmsize" {
  description = "Size of the VMs"
  default     = "Standard_B2ms"
}

variable "dx_windows10_nic" {
  description = "Network interface vpn server"
  default     = "ipconfig01"
}

# NETWORK VARIABLES ---------------------------------------------------------------------------------------------------
variable "virtual_network" {
  description = "The azurerm_virtual_network name"
  default     = "dxVPNVNet"
}

variable "vpn_gateway_subnet" {
  description = "The Gateway subnet"
  default     = "GatewaySubnet"
}

variable "vpn_client_subnet" {
  description = "The vpn client network"
  default     = "client_VPNSubnet"
}

variable "mgmt_backend_subnet" {
  description = "The backend network"
  default     = "mgmt_backendSubnet"
}

# ---------------------------------------------------------------------------------------------------------------------

# SECURITY GROUPS VARIABLES -------------------------------------------------------------------------------------------
variable "vpn_hub-sg" {
  description = "Security group for OpenVPN Server"
  default     = "vpnserver-SecurityGroup"
}

variable "client-sg" {
  description = "Security group for Windows 10 Desktop"
  default     = "client-SecurityGroup"
}

# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

