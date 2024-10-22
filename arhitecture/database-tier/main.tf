resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_mysql_server" "mysql_server" {
  name                = "mysql-server-${random_string.db_random.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  administrator_login = var.db_admin_username
  administrator_login_password = var.db_admin_password
  sku_name            = "B_Gen5_1"
  version             = "5.7"
  storage_profile {
    storage_mb = 5120
  }
}

resource "azurerm_mysql_database" "mysql_db" {
  name                = "appdb_tier3"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}

resource "random_string" "db_random" {
  length  = 8
  special = false
}