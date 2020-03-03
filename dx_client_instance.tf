variable "windows_hostname" {
  description = "The hostname of the new VM  Windows 10 desktop to be configured"
  default     = "windows01"
}

# Generate random text for a unique storage account name
resource "random_id" "dx_randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "dx_windows10_storage" {
  name                     = "diag${random_id.dx_randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  location                 = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Windows 10 Desktop: ${var.windows_hostname}"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "dx_windows" {
  name                  = "${var.windows_hostname}"
  location              = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name   = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.dx-WindowsNic.id}"]
  vm_size               = "${var.dx_windows10_vmsize}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "${var.windows_hostname}_os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    os_type           = "Windows"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "19h1-pro"
    version   = "18362.535.1912042330"
  }

  os_profile {
    computer_name  = "${var.windows_hostname}"
    admin_username = "${var.windows_username}"
    admin_password = "${var.windows_password}"
  }

  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent        = true
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.dx_windows10_storage.primary_blob_endpoint}"
  }

  tags = {
    environment = "Windows 10 Desktop: ${var.windows_hostname}"
    CreatedBy   = "BP Terraform",
    Purpose     = "Windows 10 Sandbox"
  }


  #--- Post Install Provisioning ---
}

# Create windows 10 desktop IPs
resource "azurerm_public_ip" "dx_PublicIP" {
  name                = "${var.windows_hostname}-PublicIP"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "Windows 10 Desktop: ${var.windows_hostname}"
  }
}

# Create windows 10 desktop network interface
resource "azurerm_network_interface" "dx-WindowsNic" {
  name                      = "${var.windows_hostname}Nic01"
  location                  = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name       = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_id = "${azurerm_network_security_group.client-sg.id}"

  ip_configuration {
    name                          = "${var.windows_hostname}"
    subnet_id                     = "${azurerm_subnet.vpn_hub_client_subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.dx_PublicIP.id}"
  }

  tags = {
    environment = "Windows 10 Desktop: ${var.windows_hostname}"
  }
}
