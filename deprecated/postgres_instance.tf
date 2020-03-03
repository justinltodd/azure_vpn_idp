
resource "azurerm_postgresql_server" "authdb02" {
  name                = "authdb02"
  location            = "${azurerm_resource_group.vpn_hub_vnet-rg.location}"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"

  tags = {
    environment = "PostgreSQL: authdb02 DB"
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

  administrator_login          = "authdb"
  administrator_login_password = "Pasword1234"
  version                      = "11"
  ssl_enforcement              = "Enabled"
}

resource "azurerm_postgresql_firewall_rule" "postgresql-vpn-services" {
  name                = "postgresql-vpn-azure"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  server_name         = "${azurerm_postgresql_server.authdb02.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_postgresql_firewall_rule" "postgresql-hub-mgmt" {
  name                = "postgresql-vpn-mgmt"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  server_name         = "${azurerm_postgresql_server.authdb02.name}"
  start_ip_address    = "10.1.0.32"
  end_ip_address      = "10.1.0.47"
}

resource "azurerm_postgresql_database" "authdb02" {
  name                = "authdb02"
  resource_group_name = "${azurerm_resource_group.vpn_hub_vnet-rg.name}"
  server_name         = "${azurerm_postgresql_server.authdb02.name}"
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
