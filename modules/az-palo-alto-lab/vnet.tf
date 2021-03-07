resource "azurerm_resource_group" "rg_vnet" {
  name     = "${var.nameprefix}-rg-connection-hub"
  location = var.location
}

# Network
resource "azurerm_virtual_network" "connection_hub" {
  name                = "${var.nameprefix}-vnet-connection-hub"
  address_space       = var.address_space_vnet_connection_hub
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

resource "azurerm_subnet" "fw_mgmt" {
  name                 = "fw-mgmt"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.connection_hub.name
  address_prefix       = var.address_space_subnet_fw_mgmt
}

resource "azurerm_subnet" "fw_untrusted" {
  name                 = "fw-untrusted"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.connection_hub.name
  address_prefix       = var.address_space_subnet_fw_untrusted
}

resource "azurerm_subnet" "fw_trusted" {
  name                 = "fw-trusted"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.connection_hub.name
  address_prefix       = var.address_space_subnet_fw_trusted
}

resource "azurerm_subnet" "agw_web1" {
  name                 = "agw-web1"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.connection_hub.name
  address_prefix       = var.address_space_subnet_agw_web1
}