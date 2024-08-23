resource "azurerm_virtual_network" "zwdev_vnet" {
  name                = "zwdev-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.azure_location
  resource_group_name = var.azure_resource_group
}

resource "azurerm_subnet" "zwdev_vnet_subnet_1" {
  name                 = "zwdev_vnet_subnet_1"
  resource_group_name  = var.azure_resource_group
  virtual_network_name = "zwdev-vnet"
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [
    azurerm_virtual_network.zwdev_vnet
  ]
}
