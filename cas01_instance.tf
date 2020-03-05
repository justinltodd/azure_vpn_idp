# Generate random text for a unique storage account name
resource "random_id" "cas01_randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "cas01_storage" {
  name                     = "diag${random_id.cas01_randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  location                 = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "Server: CAS01 CAS v6.2.0 Server"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "cas01" {
  name                  = "cas01"
  location              = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name   = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.cas01_nic.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "cas01_os"
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
    computer_name  = "cas01"
    admin_username = "useradmin"
    admin_password = "CHANGEME1234"
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
    storage_uri = "${azurerm_storage_account.cas01_storage.primary_blob_endpoint}"
  }

  tags = {
    environment = "Server: CAS01 CAS v6.2.0 Server"
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
      host        = "${azurerm_public_ip.CAS01PublicEth01.ip_address}"
      type        = "ssh"
      user        = "useradmin"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Pre-Created SSH Private Key - Would Recommend to recreate
  provisioner "file" {
    source      = "./ssh_keys/cas01.id_rsa"
    destination = "/root/.ssh/id_rsa"

    connection {
      host        = "${azurerm_public_ip.CAS01PublicEth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }

  # Pre-Created SSH Public Key - Would Recommend to recreate
  provisioner "file" {
    source      = "./ssh_keys/cas01.id_rsa.pub"
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
    source      = "./ssh_keys/cas01.known_hosts"
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
      "chown 600 /root/.ssh/id_rsa",
      "chown 644 /root/.ssh/id_rsa.pub",
      "chown 644 /root/.ssh/known_hosts",
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
      "hostnamectl set-hostname cas01.example-intra.com --static",
      "echo '${azurerm_network_interface.cas01_nic.private_ip_address}   cas01.example-intra.com' | cat - /etc/hosts | sudo tee /etc/hosts",
      "dnf clean packages",
      "echo 'nameserver 9.9.9.9' >> /etc/resolv.conf",
      "dnf -y install freeipa-client libsss_sudo mod_ssl git mysql",
      "systemctl endable firewalld",
      "systemctl start firewalld",
      "firewall-cmd --zone=public --add-service={freeipa-ldap,freeipa-ldaps,freeipa-replication,dns,ntp,ssh,http,https} --permanent",
      "firewall-cmd --zone=public --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,88/udp,464/tcp,464/udp,53/tcp,53/udp,123/udp,8080/tcp} --permanent",
      "firewall-cmd --reload",
      "ipa-client-install --mkhomedir --enable-dns-updates --principal=admin --password=CHANGEME1234 -U", # Setup FreeIPA Client
      "dnf -y install java-11-openjdk-devel maven apr-devel openssl-devel",
      "useradd -m -U -d /opt/tomcat -s /bin/false tomcat",
      "wget http://mirrors.ocf.berkeley.edu/apache/tomcat/tomcat-9/v9.0.31/bin/apache-tomcat-9.0.31.tar.gz -P /tmp", # tomcat v9.0.31
      "tar -xf /tmp/apache-tomcat-9.0.31.tar.gz -C /opt/tomcat/",
      "ln -s /opt/tomcat/apache-tomcat-9.0.31 /opt/tomcat/latest",
      "chown -R tomcat: /opt/tomcat",
      "sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'",
      "mkdir /etc/cas/",
      "mkdir /etc/cas/services",
      "mkdir /etc/cas/config",
      "git clone https://github.com/justinltodd/azure_vpn_idp.git /opt/workspace/azure_vpn_idp", # Clone repo for template files
      "cp /opt/workspace/azure_vpn_idp/templates/tomcat.service.centos.template /etc/systemd/system/tomcat.service",
      "cp /opt/workspace/azure_vpn_idp/templates/cas01.properties.template /etc/cas/config/cas.properties",
      "cp /opt/workspace/azure_vpn_idp/templates/log4j2.xml.template /etc/cas/config/log4j2.xml",
      "cp /opt/workspace/azure_vpn_idp/templates/HTTPSwildcard-10.cas01-example.json /etc/cas/services/HTTPSwildcard-10.json",
      "systemctl daemon-reload",
      "systemctl enable --now tomcat",
      "mkdir /var/log/cas-server",
      "touch /var/log/cas-server/cas_audit.log",
      "touch /var/log/cas-server/cas.log",
      "chown -R tomcat.tomcat /var/log/cas-server/",
      "git clone https://github.com/apereo/cas-overlay-template.git /opt/workspace/cas-overlay-template",
      "mv /opt/workspace/cas-overlay-template/build.gradle /opt/workspace/cas-overlay-template/build.gradle.$$",
      "mv /opt/workspace/cas-overlay-template/gradle.properties /opt/workspace/cas-overlay-template/gradle.properties.$$",
      "mv /opt/workspace/cas-overlay-template/settings.gradle /opt/workspace/cas-overlay-template/settings.gradle.$$",
      "cp /opt/workspace/azure_vpn_idp/templates/build.gradle.template /opt/workspace/cas-overlay-template/build.gradle",
      "cp /opt/workspace/azure_vpn_idp/templates/gradle.properties.template /opt/workspace/cas-overlay-template/gradle.properties",
      "cp /opt/workspace/azure_vpn_idp/templates/settings.gradle.template /opt/workspace/cas-overlay-template/settings.gradle",
      "wget http://download-ib01.fedoraproject.org/pub/epel/testing/8/Everything/x86_64/Packages/t/tomcat-native-1.2.23-1.el8.x86_64.rpm -P /tmp",
      "rpm -Uvh /tmp/tomcat-native-1.2.23-1.el8.x86_64.rpm",
      "alternatives --set java /usr/lib/jvm/java-11-openjdk-11.0.5.10-2.el8_1.x86_64/bin/java",
      "cd /opt/workspace/cas-overlay-template",
      "./gradlew Alldependencies",
      "./gradlew clean build",
      "ln -s /opt/workspace/cas-overlay-template/build/libs/cas.war /opt/tomcat/latest/webapps/cas.war",
      "service tomcat start",
    ]

    connection {
      host        = "${azurerm_public_ip.CAS01PublicEth01.ip_address}"
      type        = "ssh"
      user        = "root"
      private_key = "${file("${var.ssh_private_key_file}")}"
      timeout     = "5m"
    }
  }
}

# Server Public Interface Public
resource "azurerm_public_ip" "CAS01PublicEth01" {
  name                = "cas01-public"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  allocation_method   = "Static"
  domain_name_label   = "cas01" #//adds dns using hostname.centralus.cloudapp.azure.com

  tags = {
    environment = "Server: CAS01 CAS v6.2.0 Server"
  }
}

# Network Interface
resource "azurerm_network_interface" "cas01_nic" {
  name                      = "cas01-eth0"
  location                  = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name       = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  network_security_group_id = "${azurerm_network_security_group.cas01-sg.id}"
  enable_ip_forwarding      = true


  ip_configuration {
    name                          = "cas01"
    subnet_id                     = "${azurerm_subnet.vpn_hub_mgmt_subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.CAS01PublicEth01.id}"
  }

  tags = {
    environment = "Server: CAS01 CAS v6.2.0 Server`"
  }
}
