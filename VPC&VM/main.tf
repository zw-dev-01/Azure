

resource "azurerm_virtual_network" "zwdev_vnet" {
  name                = "zwdev-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.azure_location
  resource_group_name = var.azure_resource_group
}

resource "azurerm_subnet" "zwdev_vnet_subnet_1" {
  name                 = "subnet-1"
  resource_group_name  = var.azure_resource_group
  virtual_network_name = "zwdev-vnet"
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [
    azurerm_virtual_network.zwdev_vnet
  ]
}

resource "azurerm_public_ip" "zwdev_public_ip" {
  name                = "zwdev_public_ip"
  resource_group_name = var.azure_resource_group
  location            = var.azure_location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "zwdev_nic_1" {
  name                = "zwdev_nic_1"
  location            = var.azure_location
  resource_group_name = var.azure_resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.zwdev_vnet_subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.zwdev_public_ip.id
  }
}

resource "azurerm_network_security_group" "zwdev_nsg" {
  name                = "zwdev_nsg"
  location            = var.azure_location
  resource_group_name = var.azure_resource_group

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.zwdev_nic_1.id
  network_security_group_id = azurerm_network_security_group.zwdev_nsg.id
}

resource "azurerm_linux_virtual_machine" "zwdev_linux" {
  name                            = "zwdevlinux"
  resource_group_name             = var.azure_resource_group
  location                        = var.azure_location
  size                            = "Standard_D2s_v3"
  admin_username                  = "adminuser"
  admin_password                  = "The$admin#password"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.zwdev_nic_1.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}