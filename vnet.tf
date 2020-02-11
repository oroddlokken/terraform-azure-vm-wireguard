resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.deployment_name}"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.vnet_cidr]

  tags = var.tags
}

resource "azurerm_subnet" "default" {
  name                 = "snet-${var.deployment_name}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = var.vnet_default_subnet_cidr
}