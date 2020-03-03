# Generate random text for a unique storage account name
resource "random_id" "bluegate01_randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "bluegate01_storage" {
  name                     = "diag${random_id.bluegate01_randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  location                 = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Server: bluegate01 NGINX Load Balancer/Proxy"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "bluegate01" {
  name                  = "bluegate01"
  location              = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name   = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.bluegate01_nic.id}"]
  vm_size               = "Standard_DS1"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "bluegate01_os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "tunnelbiz"
    offer     = "centos8"
    sku       = "centos8minimal"
    version   = "1.9.06"
  }

  plan {
    name      = "centos8minimal"
    publisher = "tunnelbiz"
    product   = "centos8"
  }

  os_profile {
    computer_name  = "bluegate01"
    admin_username = "useradmin"
    admin_password = "Password1234"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/useradmin/.ssh/authorized_keys"
      key_data = "${file(var.ssh_public_key_file)}"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.bluegate01_storage.primary_blob_endpoint}"
  }

  tags = {
    environment = "Server: bluegate01 NGINX Load Balancer/Proxy"
  }

  # Allow root ssh access with key
  provisioner "remote-exec" {
    inline = [
      "sleep 5",
      "sudo mkdir /root/.ssh",
      "sudo chmod 700 /root/.ssh/",
      "sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys",
    ]

    connection {
      host        = "${azurerm_public_ip.bluegate01Pubeth01.ip_address}"
      type        = "ssh"
      user        = "useradmin"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Install required packages 
  provisioner "remote-exec" {
    inline = [
      "sleep 15",
      "setenforce 0",
      "sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config",
      "echo 'nameserver 9.9.9.9' >> /etc/resolv.conf",
      "mv /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.$$",
      "echo '[main]' >> /etc/NetworkManager/NetworkManager.conf",
      "echo 'dns=none' >> /etc/NetworkManager/NetworkManager.conf",
      "echo '[logging]' >> /etc/NetworkManager/NetworkManager.conf",
      "dnf -y update",
      "dnf -y install @idm:DL1 epel-release", #  install DL1 stream - freeipa stream location
      "dnf -y update",
      "hostnamectl set-hostname bluegate01.example-intra.com --static",
      "echo '${azurerm_network_interface.bluegate01_nic.private_ip_address}   bluegate01.example-intra.com' | cat - /etc/hosts | sudo tee /etc/hosts",
      "dnf clean packages",
      "echo 'nameserver 9.9.9.9' >> /etc/resolv.conf",
      "dnf -y install freeipa-client libsss_sudo certbot python3-certbot mod_ssl git mysql",
      "systemctl endable firewalld",
      "systemctl start firewalld",
      "firewall-cmd --add-service={freeipa-ldap,freeipa-ldaps,freeipa-replication,dns,ntp,ssh,http,https} --permanent",
      "firewall-cmd --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,88/udp,464/tcp,464/udp,53/tcp,53/udp,123/udp} --permanent",
      "firewall-cmd --reload",
      "ipa-client-install --mkhomedir --enable-dns-updates --principal=admin --password=CHANGEME1234 -U",
#   To-DO
#      "Re-compile nginx to include realip module",
#      "mkdir /etc/nginx/snippets/", 
#      "cp /repo/path/ngnix.conf /etc/nginx/",
#      "cp /repo/path/tomcat-basic.nginx.conf /etc/nginx/conf.d/",
      
    ]

    connection {
      host        = "${azurerm_public_ip.bluegate01Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }
}

# Server Public Interface Public
resource "azurerm_public_ip" "bluegate01Pubeth01" {
  name                = "bluegate01-public"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  allocation_method   = "Static"
  domain_name_label   = "bluegate01" #//adds dns using hostname.centralus.cloudapp.azure.com

  tags = {
    environment = "Server: bluegate01 NGINX Load Balancer/Proxy"
  }
}

# Network Interface
resource "azurerm_network_interface" "bluegate01_nic" {
  name                      = "bluegate01-eth0"
  location                  = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name       = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_id = "${azurerm_network_security_group.bluegate01-sg.id}"
  enable_ip_forwarding      = true


  ip_configuration {
    name                          = "bluegate01"
    subnet_id                     = "${azurerm_subnet.vpn_hub_mgmt_subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.bluegate01Pubeth01.id}"
  }

  tags = {
    environment = "Server: bluegate01 NGINX Load Balancer/Proxy"
  }
}
