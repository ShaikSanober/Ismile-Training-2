# Configure the Azure provider
provider "azurerm" {
  features {}
}
# Create a Resource Group
resource "azurerm_resource_group" "RG" {
  name     = "rg_name"
  location = "East US"
}
# Create a Virtual Network
resource "azurerm_virtual_network" "VNET" {
  name                = "vnet_name"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
}
# Create a Subnet
resource "azurerm_subnet" "SNET" {
  name                 = "snet_name"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = ["10.0.2.0/24"]
}
# Create a Network Interface
resource "azurerm_network_interface" "NIC" {
  name                = "nic_name"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "ip_config_name"
    subnet_id                     = azurerm_subnet.SNET.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Create a Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "L_VM" {
  name                = "vm_name"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.NIC.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}