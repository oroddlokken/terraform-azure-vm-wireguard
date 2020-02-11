resource "azurerm_key_vault" "main" {
  name                = "kv-${var.deployment_name}"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.main.name

  sku_name = "standard"

  tenant_id = var.azure_tenant_id

  enabled_for_disk_encryption = true

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = azurerm_key_vault.main.id

  tenant_id = var.azure_tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "get"
  ]

  secret_permissions = [
    "get",
    "set",
    "delete",
    "list",
    "purge"
  ]
}

resource "azurerm_key_vault_access_policy" "vm_identity" {
  key_vault_id = azurerm_key_vault.main.id

  tenant_id = var.azure_tenant_id

  object_id = azurerm_user_assigned_identity.main.principal_id

  key_permissions = [
    "get"
  ]

  secret_permissions = [
    "get",
    "set",
    "delete",
    "list",
    "purge"
  ]
}

resource "azurerm_key_vault_secret" "main" {
  name         = "wg-priv-key"
  value        = "szechuan"
  key_vault_id = azurerm_key_vault.main.id

  tags = var.tags

  depends_on = [
    azurerm_key_vault_access_policy.current
  ]
}
