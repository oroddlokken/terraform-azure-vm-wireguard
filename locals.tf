locals {
  vm_identity_id = "/subscriptions/${var.azure_subscription_id}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${azurerm_user_assigned_identity.main.name}"
}