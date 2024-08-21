output "azurerm_virtual_network_id" {
  value       = azurerm_virtual_network.zwdev_vnet.id
  description = "ID of virtual network"
}

output "zwdev_vnet_subnet_1_id" {
  value       = azurerm_subnet.zwdev_vnet_subnet_1.id
  description = "ID of virtual network subnet 1"
}