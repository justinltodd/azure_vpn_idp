# VPN01 Hostname
variable "bluevpn02_hostname" {
  description = "VPN02 hostname"
  default     = "vpn02"
}

# Internal Domain Variable
variable "BLUEVPN02_INTERNAL_DOMAIN" {
  description = "VPN01 internal search domain"
  default     = "example-intra.com"
}

# LDAP Group that VPN users need to be placed in to use VPN 
variable "BLUEVPN02_GROUP" {
  description = "VPN LDAP GROUP"
  default     = "vpnusers"
}

# Template for openvpn server configuration file ./templates/server.conf.template
data "template_file" "vpn02_server_configuration_file" {
  template = "${file("./templates/server.conf.centos.template")}"

  vars = {
    VPN_PORT           = "${var.VPN_PORT}"
    VPN_PROTOCOL       = "${var.VPN_PROTOCOL}"
    VPN_CLIENT_CIDR    = "${var.VPN_CLIENT["CIDR"]}"
    VPN_CLIENT_SUBNET  = "${var.VPN_CLIENT["SUBNET"]}"
    VPN_CLIENT_NETMASK = "${var.VPN_CLIENT["NETMASK"]}"
    VPN_HUB_SUBNET     = "${var.VPN_HUB["SUBNET"]}"
    VPN_HUB_NETMASK    = "${var.VPN_HUB["NETMASK"]}"
    VPN_DNS1           = "${var.VPN_DNS1}"
    VPN_DNS2           = "${var.VPN_DNS2}"
    LOCATION           = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
    VPN_HOST           = "${var.bluevpn02_hostname}"
    VPN_PRIVATE_IP     = "${var.VPN_PRIVATE_IP}"
    VPN_DOMAIN         = "${var.DOMAIN["VPNSERVER"]}.${var.DOMAIN["LOCATION"]}.${var.DOMAIN["ZONE"]}"
    VPN_COMPRESSION    = "${var.VPN_COMPRESSION}"
    INTERNAL_DOMAIN    = "${var.BLUEVPN02_INTERNAL_DOMAIN}"
  }
}

# Template for openvpn server LDAP PAM Auth configuration file ./templates/server.conf.template
data "template_file" "vpn02_serverLDAP_configuration_file" {
  template = "${file("./templates/server_LDAP.conf.centos.template")}"

  vars = {
    VPN_PORT           = "${var.VPN_PORT}"
    VPN_PROTOCOL       = "${var.VPN_PROTOCOL}"
    VPN_CLIENT_CIDR    = "${var.VPN_CLIENT["CIDR"]}"
    VPN_CLIENT_SUBNET  = "${var.VPN_CLIENT["SUBNET"]}"
    VPN_CLIENT_NETMASK = "${var.VPN_CLIENT["NETMASK"]}"
    VPN_HUB_SUBNET     = "${var.VPN_HUB["SUBNET"]}"
    VPN_HUB_NETMASK    = "${var.VPN_HUB["NETMASK"]}"
    VPN_DNS1           = "${var.VPN_DNS1}"
    VPN_DNS2           = "${var.VPN_DNS2}"
    LOCATION           = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
    VPN_HOST           = "${var.bluevpn02_hostname}"
    VPN_PRIVATE_IP     = "${var.VPN_PRIVATE_IP}"
    VPN_DOMAIN         = "${var.DOMAIN["VPNSERVER"]}.${var.DOMAIN["LOCATION"]}.${var.DOMAIN["ZONE"]}"
    VPN_COMPRESSION    = "${var.VPN_COMPRESSION}"
    INTERNAL_DOMAIN    = "${var.BLUEVPN02_INTERNAL_DOMAIN}"
  }
}

# Template for openvpn client configuration file ./templates/client.conf.template
data "template_file" "vpn02_client_template_file" {
  template = "${file("${var.client_template}")}"

  vars = {
    VPN_PORT           = "${var.VPN_PORT}"
    VPN_PROTOCOL       = "${var.VPN_PROTOCOL}"
    VPN_CLIENT_CIDR    = "${var.VPN_CLIENT["CIDR"]}"
    VPN_CLIENT_SUBNET  = "${var.VPN_CLIENT["SUBNET"]}"
    VPN_CLIENT_NETMASK = "${var.VPN_CLIENT["NETMASK"]}"
    VPN_HUB_SUBNET     = "${var.VPN_HUB["SUBNET"]}"
    VPN_HUB_NETMASK    = "${var.VPN_HUB["NETMASK"]}"
    VPN_DNS1           = "${var.VPN_DNS1}"
    VPN_DNS2           = "${var.VPN_DNS2}"
    LOCATION           = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
    VPN_HOST           = "${var.bluevpn02_hostname}"
    VPN_PRIVATE_IP     = "${var.VPN_PRIVATE_IP}"
    VPN_DOMAIN         = "${var.DOMAIN["VPNSERVER"]}.${var.DOMAIN["LOCATION"]}.${var.DOMAIN["ZONE"]}"
    VPN_COMPRESSION    = "${var.VPN_COMPRESSION}"
  }
}

# Template for openvpn client LDAPAUTH configuration file ./templates/client.conf.template
data "template_file" "vpn02_clientLDAPAuth_template_file" {
  template = "${file("./templates/client_LDAPAuth.conf.template")}"

  vars = {
    VPN_PORT           = "${var.VPN_PORT}"
    VPN_PROTOCOL       = "${var.VPN_PROTOCOL}"
    VPN_CLIENT_CIDR    = "${var.VPN_CLIENT["CIDR"]}"
    VPN_CLIENT_SUBNET  = "${var.VPN_CLIENT["SUBNET"]}"
    VPN_CLIENT_NETMASK = "${var.VPN_CLIENT["NETMASK"]}"
    VPN_HUB_SUBNET     = "${var.VPN_HUB["SUBNET"]}"
    VPN_HUB_NETMASK    = "${var.VPN_HUB["NETMASK"]}"
    VPN_DNS1           = "${var.VPN_DNS1}"
    VPN_DNS2           = "${var.VPN_DNS2}"
    LOCATION           = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
    VPN_HOST           = "${var.bluevpn02_hostname}"
    VPN_PRIVATE_IP     = "${var.VPN_PRIVATE_IP}"
    VPN_DOMAIN         = "${var.DOMAIN["VPNSERVER"]}.${var.DOMAIN["LOCATION"]}.${var.DOMAIN["ZONE"]}"
    VPN_COMPRESSION    = "${var.VPN_COMPRESSION}"
  }
}

# Template lighttpd configration file ./templates/lighttpd_centos.template
data "template_file" "vpn02_lighttpd_template_file" {
  template = "${file("./templates/lighttpd_centos.template")}"

  vars = {
    HOST     = "${var.bluevpn02_hostname}"
    LOCATION = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
    ADMIN    = "useradmin"
    PASS     = "***"
  }
}

# Template for openvpn pam LDAP auth  configuration ./templates/lighttpd_centos.template
data "template_file" "vpn02_openvpn_pam_template_file" {
  template = "${file("./templates/openvpn.pam.template")}"

  vars = {
    GROUP = "${var.BLUEVPN02_GROUP}"
  }
}

# Generate random text for a unique storage account name
resource "random_id" "bluevpn02_randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "bluevpn02_storage" {
  name                     = "diag${random_id.bluevpn02_randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  location                 = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Server: ${var.bluevpn02_hostname}"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "bluevpn02" {
  name                  = "${var.bluevpn02_hostname}"
  location              = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name   = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.bluevpn02_nic.id}"]
  vm_size               = "Standard_D2s_v3"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "${var.bluevpn02_hostname}_os"
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
    computer_name  = "${var.bluevpn02_hostname}"
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
    storage_uri = "${azurerm_storage_account.bluevpn02_storage.primary_blob_endpoint}"
  }

  tags = {
    environment = "Server: ${var.bluevpn02_hostname}"
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
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "useradmin"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Root Access
  provisioner "remote-exec" {
    inline = [
      "sleep 5",
      # -- Beginning Network Manager -- #
      "echo 'nameserver 9.9.9.9' >> /etc/resolv.conf",
      "mv /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.$$",
      "echo '[main]' >> /etc/NetworkManager/NetworkManager.conf",
      "echo 'dns=none' >> /etc/NetworkManager/NetworkManager.conf",
      "echo '[logging]' >> /etc/NetworkManager/NetworkManager.conf",
      # -- End Network Manager -- #
      "dnf -y update",
      "dnf -y install @idm:DL1 epel-release", #  install DL1 stream - freeipa stream location
      "dnf -y install freeipa-client libsss_sudo certbot python3-certbot mod_ssl git openvpn openvpn-devel make openssl gcc lighttpd git",
      "dnf clean packages",
      "dnf -y update",
      "curl -s https://api.github.com/repos/OpenVPN/easy-rsa/releases/latest | grep 'browser_download_url.*tgz' | cut -d : -f 2,3 | tr -d '$\"' | awk '!/sig/' | wget -O /tmp/EasyRSA.tgz -qi -",
      "tar -zxvf /tmp/EasyRSA.tgz --transform 's/EasyRSA-v3.0.6/easy-rsa/' --one-top-level=/etc/openvpn/",
      "chown -R root:root /etc/openvpn/easy-rsa/",
      "rm -rf /tmp/EasyRSA.tgz",
    ]

    connection {
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Provision dh.pem - Create the DH parameters file using the predefined ffdhe2048 group
  provisioner "file" {
    source      = "./templates/dh4096.pem.template"
    destination = "/etc/openvpn/server/dh4096.pem" #moves to /etc/openvpn/server/

    connection {
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Render the vars file for easy-rsa CA creation
  provisioner "file" {
    source      = "./templates/letsencrypt.vars.template"
    destination = "/etc/openvpn/easy-rsa/vars" # moves to /etc/openvpn/easy-rsa/vars

    connection {
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Script HTTP website - create vpn client certs
  provisioner "file" {
    source      = "./scripts/index.sh"
    destination = "/var/www/html/index.sh"

    connection {
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Script HTTP website - download vpn certs
  provisioner "file" {
    source      = "./scripts/download.sh"
    destination = "/var/www/html/download.sh"

    connection {
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Render the lighttpd.conf template file
  provisioner "file" {
    content     = "${data.template_file.vpn02_lighttpd_template_file.rendered}"
    destination = "/etc/lighttpd/lighttpd.conf"

    connection {
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Render the server.centos.conf.template template file -> server.conf
  provisioner "file" {
    content     = "${data.template_file.vpn02_server_configuration_file.rendered}"
    destination = "/etc/openvpn/server/server.conf"

    connection {
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Render the serverLDAP.centos.conf.template template file -> server.conf
  provisioner "file" {
    content     = "${data.template_file.vpn02_serverLDAP_configuration_file.rendered}"
    destination = "/etc/openvpn/server/serverLDAP.conf.template"

    connection {
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Render the client.conf.template template file
  provisioner "file" {
    content     = "${data.template_file.vpn02_client_template_file.rendered}"
    destination = "/etc/openvpn/client.conf.template"

    connection {
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Render the clientLDAPAuth.conf.template template file
  provisioner "file" {
    content     = "${data.template_file.vpn02_clientLDAPAuth_template_file.rendered}"
    destination = "/etc/openvpn/client_LDAPAuth.conf.template"

    connection {
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Render the openvpn.pam.template template file
  provisioner "file" {
    content     = "${data.template_file.vpn02_openvpn_pam_template_file.rendered}"
    destination = "/etc/pam.d/openvpn"

    connection {
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # VPN/Encryption/LDAP Client Build - Hostname Config
  provisioner "remote-exec" {
    inline = [
      "sleep 15",
      "mkdir /var/log/openvpn/",
      "systemctl start firewalld",
      "systemctl enable firewalld",
      "firewall-cmd --add-service={freeipa-ldap,freeipa-ldaps,dns,ntp,ssh,http,https,openvpn} --permanent",
      "firewall-cmd --zone=trusted --add-service openvpn",
      "firewall-cmd --zone=trusted --add-service openvpn --permanent",
      "firewall-cmd --add-masquerade",
      "firewall-cmd --permanent --add-masquerade",
      "firewall-cmd --permanent --direct --passthrough ipv4 -t nat -A POSTROUTING -s 10.8.0.0/24 -o ${azurerm_network_interface.bluevpn02_nic.private_ip_address} -j MASQUERADE",
      "firewall-cmd --reload",
      "echo '# OpenVpn IP Forwarding' >> /etc/sysctl.d/100-openvpn.conf",
      "echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.d/100-openvpn.conf",
      "sysctl -w net.ipv4.ip_forward=1",
      "setenforce 0",
      "sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config",
      "systemctl enable openvpn-server@server.service",
      "hostnamectl set-hostname ${var.bluevpn02_hostname}.example-intra.com --static",
      "echo '${azurerm_network_interface.bluevpn02_nic.private_ip_address}   ${var.bluevpn02_hostname}.example-intra.com' | cat - /etc/hosts | sudo tee /etc/hosts",
      "ipa-client-install --mkhomedir --enable-dns-updates --principal=admin --password=CHANGEME1234 -U",
      "sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config", # <-- DIsable SELINUX - Still requires reboot
      "cd /etc/openvpn/easy-rsa/",
      "./easyrsa init-pki",
      "touch /etc/openvpn/easy-rsa/pki/.rnd",
      "./easyrsa --batch --req-cn=${var.bluevpn02_hostname}-RootCA build-ca nopass",
      "./easyrsa build-server-full  ${var.bluevpn02_hostname} nopass",
      "./easyrsa gen-crl",
      "cp pki/ca.crt pki/private/ca.key pki/issued/${var.bluevpn02_hostname}.crt pki/private/${var.bluevpn02_hostname}.key /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/server/",
      "chown nobody.nobody /etc/openvpn/server/crl.pem",
      "openvpn --genkey --secret /etc/openvpn/server/ta.key",
      "mkdir /etc/openvpn/clients/",
      "chown -R lighttpd.lighttpd /etc/openvpn/easy-rsa",
      "chown -R lighttpd.lighttpd /etc/openvpn/clients/",
      "chown -R lighttpd.lighttpd /var/www/html/",
      "chmod -R 755 /etc/openvpn/",
      "chmod -R 777 /etc/openvpn/server/crl.pem",
      "chmod 700 /etc/openvpn/server/${var.bluevpn02_hostname}.key",
      "chmod 755 /etc/openvpn/server/ta.key",
      "chmod g+s /etc/openvpn/clients/",
      "chmod g+s /etc/openvpn/easy-rsa/",
      "certbot certonly --standalone -n -d ${var.bluevpn02_hostname}.centralus.cloudapp.azure.com --email noreply@example.com --agree-tos --redirect --hsts",
      "cat /etc/letsencrypt/live/${var.bluevpn02_hostname}.${azurerm_resource_group.vpn_hub_vnet-rg.location}.cloudapp.azure.com/privkey.pem /etc/letsencrypt/live/${var.bluevpn02_hostname}.${azurerm_resource_group.vpn_hub_vnet-rg.location}.cloudapp.azure.com/cert.pem > /etc/letsencrypt/live/${var.bluevpn02_hostname}.${azurerm_resource_group.vpn_hub_vnet-rg.location}.cloudapp.azure.com/combined.pem",
      "echo 'useradmin:CHANGEME1234' >> /etc/lighttpd/.lighttpdpassword",
      "systemctl enable lighttpd",
      "systemctl start lighttpd",
      "systemctl start openvpn-server@server.service",
    ]

    connection {
      host        = "${azurerm_public_ip.bluevpn02Pubeth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }
}


# Server Public Interface Public
resource "azurerm_public_ip" "bluevpn02Pubeth01" {
  name                = "${var.bluevpn02_hostname}-public"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  allocation_method   = "Static"
  domain_name_label   = "${var.bluevpn02_hostname}" #//adds dns using hostname.centralus.cloudapp.azure.com

  tags = {
    environment = "Server: ${var.bluevpn02_hostname}"
  }
}

# Network Interface
resource "azurerm_network_interface" "bluevpn02_nic" {
  name                      = "${var.bluevpn02_hostname}-eth0"
  location                  = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name       = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_id = "${azurerm_network_security_group.bluevpn02-sg.id}"
  enable_ip_forwarding      = true


  ip_configuration {
    name                          = "${var.bluevpn02_hostname}"
    subnet_id                     = "${azurerm_subnet.vpn_hub_subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.bluevpn02Pubeth01.id}"
  }

  tags = {
    environment = "Server: ${var.bluevpn02_hostname}"
  }
}

