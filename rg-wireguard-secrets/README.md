# Terraform deployment for WireGuard secrets

Note: ignore_changes=[value] is defined in the `azurerm_key_vault_secret` resource. This is so we can bootstrap the key vault with a placeholder secret if we want, so we later can update the secret with the actual private key. This way we avoid storing secrets in `terraform.tfstate/terraform.tfvars`.