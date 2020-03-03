
resource "azurerm_mariadb_server" "authdb01" {
  name                = "authdb01"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"

  tags = {
    environment = "MariaDB: authdb01 MariaDB"
  }

  sku {
    name     = "B_Gen5_2"
    capacity = "2"
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = "10240"
    backup_retention_days = "7"
    geo_redundant_backup  = "Disabled"
    auto_grow             = "Enabled"
  }

  administrator_login          = "dbadmin"
  administrator_login_password = "Password1234"
  version                      = "10.3"
  ssl_enforcement              = "Disabled"
}

resource "azurerm_mariadb_firewall_rule" "mariadb-vpn-services" {
  name                = "mariadb-vpn-azure"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  server_name         = "${azurerm_mariadb_server.authdb01.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mariadb_firewall_rule" "mariadb-hub-mgmt" {
  name                = "mariadb-vpn-mgmt"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  server_name         = "${azurerm_mariadb_server.authdb01.name}"
  start_ip_address    = "10.1.0.32"
  end_ip_address      = "10.1.0.47"
}

resource "azurerm_mariadb_database" "authdb01" {
  name                = "authdb01"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  server_name         = "${azurerm_mariadb_server.authdb01.name}"
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
