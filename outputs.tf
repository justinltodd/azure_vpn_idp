output "BLUEVPN01_public_ip" {
  value = "The BLUEVPN01 Public IP Address: ${azurerm_public_ip.bluevpn01Pubeth01.ip_address}"
}

output "BLUEVPN01_private_ip" {
  value = "The BLUEVPN01 Private IP Address: ${azurerm_network_interface.bluevpn01_nic.private_ip_address}"
}

output "BLUEVPN02_public_ip" {
  value = "The BLUEVPN02 Public IP Address: ${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
}

output "BLUEVPN02_private_ip" {
  value = "The BLUEVPN02 Private IP Address: ${azurerm_network_interface.bluevpn02_nic.private_ip_address}"
}

output "BLUEMGMT01_public_ip" {
  value = "The BLUEMGMT01 Public IP Address: ${azurerm_public_ip.bluemgmt01Pubeth01.ip_address}"
}

output "BLUEMGMT01_private_ip" {
  value = "The BLUEMGMT01 Private IP Address: ${azurerm_network_interface.bluemgmt01_nic.private_ip_address}"
}

output "BLUEGATE01_public_ip" {
  value = "The BLUEMGMT01 Public IP Address: ${azurerm_public_ip.bluegate01Pubeth01.ip_address}"
}

output "BLUEGATE01_private_ip" {
  value = "The BLUEMGMT01 Private IP Address: ${azurerm_network_interface.bluegate01_nic.private_ip_address}"
}

output "CAS01_public_ip" {
  value = "CAS01 Public IP Address: ${azurerm_public_ip.CAS01PublicEth01.ip_address}"
}

output "CAS01_private_ip" {
  value = "CAS01 Private IP Address: ${azurerm_network_interface.cas01_nic.private_ip_address}"
}

output "CAS02_public_ip" {
  value = "CAS02 Public IP Address: ${azurerm_public_ip.CAS02PublicEth01.ip_address}"
}

output "CAS02_private_ip" {
  value = "CAS02 Private IP Address: ${azurerm_network_interface.cas02_nic.private_ip_address}"
}

output "nsldap01_public_ip" {
  value = "nsldap01 Public IP Address: ${azurerm_public_ip.nsldap01Pubeth01.ip_address}"
}

output "nsldap01_private_ip" {
  value = "nsldap01 Private IP Address: ${azurerm_network_interface.nsldap01_nic.private_ip_address}"
}

output "nsldap02_public_ip" {
  value = "nsldap02 Public IP Address: ${azurerm_public_ip.nsldap02Pubeth01.ip_address}"
}

output "nsldap02_private_ip" {
  value = "nsldap02 Private IP Address: ${azurerm_network_interface.nsldap02_nic.private_ip_address}"
}

output "windows10_public_ip" {
  value = "Windows10 Pro Test Client Public IP Address: ${azurerm_public_ip.dx_PublicIP.ip_address} - Disable"
}

output "windows10_private_ip" {
  value = "Windows10 Pro Test  Private IP Address: ${azurerm_network_interface.dx-WindowsNic.private_ip_address}"
}
