resource "random_id" "bootdiag" {
  keepers = {
    resource_group = azurerm_resource_group.main.name
  }

  byte_length = 16
}

locals {
  bootdiag_storage_account_name = substr("stbootdiag${random_id.bootdiag.hex}", 0, 23)
}

resource "azurerm_storage_account" "bootdiag" {
  name = local.bootdiag_storage_account_name

  resource_group_name = azurerm_resource_group.main.name
  location            = var.azure_location

  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = var.tags
}
