# Generate random text for a unique storage account name
resource "random_id" "nsldap01_randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "nsldap01_storage" {
  name                     = "diag${random_id.nsldap01_randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  location                 = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Server: nsldap01 FreeIPA LDAP DNS Server"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "nsldap01" {
  name                  = "nsldap01"
  location              = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name   = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.nsldap01_nic.id}"]
  vm_size               = "Standard_D2s_v3"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "nsldap01_os"
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
    computer_name  = "nsldap01"
    admin_username = "useradmin"
    admin_password = "****"
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
    storage_uri = "${azurerm_storage_account.nsldap01_storage.primary_blob_endpoint}"
  }

  tags = {
    environment = "Server: nsldap01 FreeIPA LDAP DNS Server"
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
      host        = "${azurerm_public_ip.nsldap01Pubeth01.ip_address}"
      type        = "ssh"
      user        = "useradmin"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Pre-Created SSH Private Key - Would Recommend to recreate
  provisioner "file" {
    source      = "./ssh_keys/nsldap01.id_rsa"
    destination = "/root/.ssh/id_rsa"

    connection {
      host        = "${azurerm_public_ip.CAS01PublicEth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Pre-Created SSH Prublic Key - Would Recommend to recreate
  provisioner "file" {
    source      = "./ssh_keys/nsldap01.id_rsa.pub"
    destination = "/root/.ssh/id_rsa.pub"

    connection {
      host        = "${azurerm_public_ip.CAS01PublicEth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # SSH known_Hosts template - Added Bitbucket and GitHub
  provisioner "file" {
    source      = "./ssh_keys/nsldap01.known_hosts"
    destination = "/root/.ssh/known_hosts"

    connection {
      host        = "${azurerm_public_ip.CAS01PublicEth01.ip_address}"
      type        = "ssh"
      user        = "root"
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
      "hostnamectl set-hostname nsldap01.example-intra.com --static",
      "echo '${azurerm_network_interface.nsldap01_nic.private_ip_address}   nsldap01.example-intra.com' | cat - /etc/hosts | sudo tee /etc/hosts",
      "dnf clean packages",
      "echo 'nameserver 9.9.9.9' >> /etc/resolv.conf",
      "dnf -y install ipa-server ipa-server-dns",
      "systemctl endable firewalld",
      "systemctl start firewalld",
      "firewall-cmd --add-service={freeipa-ldap,freeipa-ldaps,freeipa-replication,dns,ntp,ssh,http,https} --permanent",
      "firewall-cmd --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,88/udp,464/tcp,464/udp,53/tcp,53/udp,123/udp} --permanent",
      "firewall-cmd --reload",
      "ipa-server-install --admin-password=PASSWORDCHANGE --realm=EXAMPLE-INTRA.COM --ds-password=PASSOWRDCHANGE1234 --domain=example-intra.com --hostname=nsldap01.example-intra.com --setup-dns --forwarder=9.9.9.9 --forwarder=149.112.112.112 --reverse-zone=0.1.10.in-addr.arpa. --forward-policy=only -U",
      "rm -rf /var/lib/ipa/backup",
      "git clone git@bitbucket.org:blueprism-tsa/nsldap01_backup.git",
      "ln -s /opt/nsldap01_backup/ /var/lib/ipa/backup",
    ]

    connection {
      host        = "${azurerm_public_ip.nsldap01Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }
}

# Server Public Interface Public
resource "azurerm_public_ip" "nsldap01Pubeth01" {
  name                = "nsldap01-public"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  allocation_method   = "Static"
  domain_name_label   = "nsldap01" #//adds dns using hostname.centralus.cloudapp.azure.com

  tags = {
    environment = "Server: ldap FreeIPA LDAP DNS Server"
  }
}

# Network Interface
resource "azurerm_network_interface" "nsldap01_nic" {
  name                      = "nsldap01-eth0"
  location                  = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name       = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_id = "${azurerm_network_security_group.nsldap01-sg.id}"
  enable_ip_forwarding      = true


  ip_configuration {
    name                          = "nsldap01"
    subnet_id                     = "${azurerm_subnet.vpn_hub_mgmt_subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.nsldap01Pubeth01.id}"
  }

  tags = {
    environment = "Server: nsldap01 FreeIPA LDAP DNS Server"
  }
}
