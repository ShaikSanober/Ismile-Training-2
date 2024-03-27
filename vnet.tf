# Configure the Azure provider
provider "azurerm" {
  features {}
}
# Create a Resource Group
resource "azurerm_resource_group" "RG" {
  name     = "rg_name"
  location = "East US"
}
# Create a Network Security Group
resource "azurerm_network_security_group" "NSG" {
  name                = "nsg_name"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
}
# Create a Virtual Network
resource "azurerm_virtual_network" "VNET" {
  name                = "vnet_name"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
# Create a Subnet
  subnet {
    name           = "snet1_name"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "snet2_name"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.NSG.id
  }

  tags = {
    environment = "Production"
  }
}