resource "azurerm_resource_group" "main" {
  name     = "rg-${var.deployment_name}-secrets"
  location = var.azure_location

  tags = var.tags
}