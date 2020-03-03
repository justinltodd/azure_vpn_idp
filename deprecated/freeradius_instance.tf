# Generate random text for a unique storage account name
resource "random_id" "radius_randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "dx_radius_storage" {
  name                     = "diag${random_id.radius_randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  location                 = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Server: freeradius01"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "freeradius" {
  name                  = "freeradius01"
  location              = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name   = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.freeradius_nic.id}"]
  vm_size               = "Standard_B2ms"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "freeradius01_os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "freeradius01"
    admin_username = "dxadmin"
    admin_password = "Password1234"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/dxadmin/.ssh/authorized_keys"
      key_data = "${file(var.ssh_public_key_file)}"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.dx_radius_storage.primary_blob_endpoint}"
  }

  tags = {
    environment = "Server: freeradius01"
  }

  # Allow root ssh access with key
  provisioner "remote-exec" {
    inline = [
      "sleep 5",
      "sudo cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys.$$",
      "sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys",
    ]

    connection {
      host        = "${azurerm_public_ip.PublicEth0.ip_address}"
      type        = "ssh"
      user        = "dxadmin"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Install required packages 
  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "sudo echo 'deb http://packages.networkradius.com/releases/ubuntu-bionic bionic main' >> /etc/apt/sources.list",
      "sudo apt-key adv --keyserver keys.gnupg.net --recv-key 0x41382202",
      "sudo apt-get update",
      "sudo apt-get -y upgrade",
      "sudo apt-get -y autoremove",
      "sudo apt-get -y install curl wget",
      "sudo add-apt-repository universe",
      "sudo add-apt-repository -y ppa:certbot/certbot",
      "sudo apt-get -y install gcc software-properties-common",
      "sudo apt-get -y install make",
      "sudo apt-get -y install ca-certificates",
      "sudo apt-get -y install openssl",
      "sudo apt-get -y install certbot",
      "sudo apt-get -y update",
      "sudo apt-get -y install freeradius freeradius-ldap freeradius-postgresql freeradius-mysql freeradius-krb5 snmp libclone-perl libmldbm-perl libnet-daemon-perl libsql-statement-perl postgresql-client",
      "sudo apt-get -y install php-common php-gd php-curl",
      "sudo systemctl enable freeradius.service",
    ]

    connection {
      host        = "${azurerm_public_ip.PublicEth0.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }
}

# Radius Server Public Interface  PublicEth0
resource "azurerm_public_ip" "PublicEth0" {
  name                = "freeradius01-public"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  allocation_method   = "Static"
  domain_name_label   = "freeradius01" #//adds dns using hostname.centralus.cloudapp.azure.com

  tags = {
    environment = "Server: freeradius01"
  }
}

# FreeRadius Network Interface
resource "azurerm_network_interface" "freeradius_nic" {
  name                      = "freeradius01-eth0"
  location                  = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name       = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_id = "${azurerm_network_security_group.freeradius-sg.id}"
  enable_ip_forwarding      = true


  ip_configuration {
    name                          = "freeradius01"
    subnet_id                     = "${azurerm_subnet.vpn_hub_mgmt_subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.PublicEth0.id}"
  }

  tags = {
    environment = "Server: freeradius01"
  }
}
