# Terraform deployment for WireGuard secrets

Note: ignore_changes=[value] is defined in the `azurerm_key_vault_secret` resource. This is so we can bootstrap the key vault with a placeholder secret, and later update the key vault with the real private key.