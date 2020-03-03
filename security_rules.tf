###            ###
# Security Rules #
###            ###


# BLUEVPN01 Server Network Security Group
resource "azurerm_network_security_group" "bluevpn01-sg" {
  name                = "bluevpn01-sg"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
}

# BLUEVPN02 Server Network Security Group
resource "azurerm_network_security_group" "bluevpn02-sg" {
  name                = "bluevpn02-sg"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
}

# bluemgmt01 admin portal  Network Security Group
resource "azurerm_network_security_group" "bluemgmt01-sg" {
  name                = "bluemgmt01-sg"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
}

# bluemgmt01 admin portal  Network Security Group
resource "azurerm_network_security_group" "bluegate01-sg" {
  name                = "bluegate01-sg"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
}

# Windows 10 Desktop Network Security Group
resource "azurerm_network_security_group" "client-sg" {
  name                = "${var.client-sg}"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
}

# CAS02  Server  Network Security Group
resource "azurerm_network_security_group" "cas01-sg" {
  name                = "cas01-sg"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
}

# CAS02  Server  Network Security Group
resource "azurerm_network_security_group" "cas02-sg" {
  name                = "cas02-sg"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
}

# nsldap01  Server  Network Security Group
resource "azurerm_network_security_group" "nsldap01-sg" {
  name                = "nsldap01-sg"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
}

# nsldap02  Server  Network Security Group
resource "azurerm_network_security_group" "nsldap02-sg" {
  name                = "nsldap02-sg"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
}

# NOTE: //Here opened HTTPS 8443 port bluemgmt01-sg
resource "azurerm_network_security_rule" "BLUEMGMT01_HTTPS_443" {
  name                        = "443PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluemgmt01-sg.name}"
  priority                    = 220
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTP 80 port bluemgmt01-sg
resource "azurerm_network_security_rule" "BLUEMGMT01_HTTP_80" {
  name                        = "80PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluemgmt01-sg.name}"
  priority                    = 225
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened SSH 22 port bluemgmt01-sg
resource "azurerm_network_security_rule" "BLUEMGMT01_SSH_22" {
  name                        = "22PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluemgmt01-sg.name}"
  priority                    = 230
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTPS 8443 port bluegate01-sg
resource "azurerm_network_security_rule" "BLUEGATE01_HTTPS_443" {
  name                        = "443PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluegate01-sg.name}"
  priority                    = 220
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTP 80 port bluegate01-sg
resource "azurerm_network_security_rule" "BLUEGATE01_HTTP_80" {
  name                        = "80PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluegate01-sg.name}"
  priority                    = 225
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened SSH 22 port bluegate01-sg
resource "azurerm_network_security_rule" "BLUEGATE01_SSH_22" {
  name                        = "22PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluegate01-sg.name}"
  priority                    = 230
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTPS 443 port nsldap02-sg
resource "azurerm_network_security_rule" "NSLDAP02_HTTPS_443" {
  name                        = "443PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nsldap02-sg.name}"
  priority                    = 220
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "10.0.0.0/8"
}

# NOTE: //Here opened HTTP 80 port nsldap02-sg
resource "azurerm_network_security_rule" "NSLDAP02_HTTP_80" {
  name                        = "80PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nsldap02-sg.name}"
  priority                    = 225
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "10.0.0.0/8"
}

# NOTE: //Here opened SSH 22 port nsldap02-sg
resource "azurerm_network_security_rule" "NSLDAP02_SSH_22" {
  name                        = "22PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nsldap02-sg.name}"
  priority                    = 230
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTPS 8443 port nsldap01-sg
resource "azurerm_network_security_rule" "NSLDAP01_HTTPS_443" {
  name                        = "443PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nsldap01-sg.name}"
  priority                    = 220
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "10.0.0.0/8"
}

# NOTE: //Here opened HTTP 80 port nsldap01-sg
resource "azurerm_network_security_rule" "NSLDAP01_HTTP_80" {
  name                        = "80PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nsldap01-sg.name}"
  priority                    = 225
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "10.0.0.0/8"
  destination_address_prefix  = "10.0.0.0/8"
}

# NOTE: //Here opened SSH 22 port nsldap01-sg
resource "azurerm_network_security_rule" "NSLDAP01_SSH_22" {
  name                        = "22PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nsldap01-sg.name}"
  priority                    = 230
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTPS 8443 port cas01-sg
resource "azurerm_network_security_rule" "CAS01_HTTPS_8443" {
  name                        = "8443PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.cas01-sg.name}"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTP 8080 port cas01-sg
resource "azurerm_network_security_rule" "CAS01_HTTP_8080" {
  name                        = "8080PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.cas01-sg.name}"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTP 80 port cas01-sg
resource "azurerm_network_security_rule" "CAS01_HTTP_80" {
  name                        = "HTTPPermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.cas01-sg.name}"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTP 80 port cas01-sg
resource "azurerm_network_security_rule" "CAS01_HTTPS_443" {
  name                        = "HTTPSPermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.cas01-sg.name}"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTP 80 port cas01-sg
resource "azurerm_network_security_rule" "CAS01_SSH_IN" {
  name                        = "PermitSSHInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.cas01-sg.name}"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTPS 8443 port cas02-sg
resource "azurerm_network_security_rule" "CAS02_HTTPS_8443" {
  name                        = "8443PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.cas02-sg.name}"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTP 8080 port cas02-sg
resource "azurerm_network_security_rule" "CAS02_HTTP_8080" {
  name                        = "8080PermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.cas02-sg.name}"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTP 80 port cas02-sg
resource "azurerm_network_security_rule" "CAS02_HTTP_80" {
  name                        = "HTTPPermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.cas02-sg.name}"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTP 80 port cas02-sg
resource "azurerm_network_security_rule" "CAS02_HTTPS_443" {
  name                        = "HTTPSPermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.cas02-sg.name}"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened HTTP 80 port cas02-sg
resource "azurerm_network_security_rule" "CAS02_SSH_IN" {
  name                        = "PermitSSHInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.cas02-sg.name}"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Here opened remote desktop port client-sg
resource "azurerm_network_security_rule" "RDP-in" {
  name                        = "RDPPermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.client-sg.name}"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Opened WinRM Port Windows client-sg
resource "azurerm_network_security_rule" "WinRM-in" {
  name                        = "WinRMPermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.client-sg.name}"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5985"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Opened Outbound WinRM Port Windows client-sg
resource "azurerm_network_security_rule" "WinRM-out" {
  name                        = "WinRMPermitOutbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.client-sg.name}"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5985"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: //Opened HTTPS port client-sg
resource "azurerm_network_security_rule" "windows10_HTTPS" {
  name                        = "HTTPSPermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.client-sg.name}"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: BLUEVPN01 this allows SSH from any network bluevpn01-sg
resource "azurerm_network_security_rule" "BLUEVPN01_SSH" {
  name                        = "PermitSSHInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluevpn01-sg.name}"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: BLUEVPN01 this allows VPN from Internet bluevpn01-sg
resource "azurerm_network_security_rule" "BLUEVPN01_VPN" {
  name                        = "PermitOpenVPNInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluevpn01-sg.name}"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "1194"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: BLUEVPN01 this allows HTTPS access to client ovpn file from Internet bluevpn01-sg
resource "azurerm_network_security_rule" "BLUEVPN01_HTTPS" {
  name                        = "HTTPSPermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluevpn01-sg.name}"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: BLUEVPN01 this allows HTTPS access to client ovpn file from Internet bluevpn01-sg
resource "azurerm_network_security_rule" "BLUEVPN01_HTTP" {
  name                        = "HTTPPermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluevpn01-sg.name}"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: BLUEVPN01 this allows SSH from any network bluevpn01-sg
resource "azurerm_network_security_rule" "BLUEVPN02_SSH" {
  name                        = "PermitSSHInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluevpn02-sg.name}"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: BLUEVPN01 this allows VPN from Internet bluevpn02-sg
resource "azurerm_network_security_rule" "BLUEVPN02_VPN" {
  name                        = "PermitOpenVPNInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluevpn02-sg.name}"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "1194"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: BLUEVPN01 this allows HTTPS access to client ovpn file from Internet bluevpn02-sg
resource "azurerm_network_security_rule" "BLUEVPN02_HTTPS" {
  name                        = "HTTPSPermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluevpn02-sg.name}"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# NOTE: BLUEVPN01 this allows HTTPS access to client ovpn file from Internet bluevpn02-sg
resource "azurerm_network_security_rule" "BLUEVPN02_HTTP" {
  name                        = "HTTPPermitInbound"
  resource_group_name         = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_name = "${azurerm_network_security_group.bluevpn02-sg.name}"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}
