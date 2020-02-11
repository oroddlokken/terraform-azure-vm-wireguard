resource "azurerm_user_assigned_identity" "main" {
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.main.name

  name = "identity-${var.deployment_name}"
}

resource "azurerm_role_definition" "vm_user" {
  name  = "vm_user"
  scope = "/subscriptions/${var.azure_subscription_id}"

  permissions {
    actions = []
  }

  assignable_scopes = [
    "/subscriptions/${var.azure_subscription_id}",
  ]
}

resource "azurerm_role_assignment" "vm_user" {
  scope = "/subscriptions/${var.azure_subscription_id}"

  role_definition_id = azurerm_role_definition.vm_user.id
  principal_id       = azurerm_user_assigned_identity.main.principal_id
}

resource "azurerm_key_vault_access_policy" "vm_identity" {
  key_vault_id = data.azurerm_key_vault.main.id

  tenant_id = var.azure_tenant_id

  object_id = azurerm_user_assigned_identity.main.principal_id

  key_permissions = [
    "get"
  ]

  secret_permissions = [
    "get",
  ]
}