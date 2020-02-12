# Terraform deployment for WireGuard secrets

Note: ignore_changes=[value] is defined in the `azurerm_key_vault_secret` resource. This is so we can bootstrap the key vault with a placeholder secret if we want, so we later can update the secret with the actual private key. This way we avoid storing secrets in `terraform.tfstate/terraform.tfvars`.

## Example `terraform.tfvars`
```
azure_tenant_id       = "some_tenant_id"
azure_subscription_id = "some_subscription_id"
azure_location        = "Norway East"
deployment_name       = "my-wireguard"

wireguard_private_key = "some_string" # This can be rotated later if you don't want your actual private key to be stored in the state file.
```