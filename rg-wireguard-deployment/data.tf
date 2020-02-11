data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "secrets" {
  name = "rg-${var.deployment_name}-secrets"
}

data "azurerm_key_vault" "main" {
  name                = "kv-${var.deployment_name}"
  resource_group_name = data.azurerm_resource_group.secrets.name
}
