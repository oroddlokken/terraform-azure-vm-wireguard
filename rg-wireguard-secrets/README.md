# Terraform deployment for WireGuard secrets

Note: ignore_changes=[value] is defined in the `azurerm_key_vault_secret` resource. This is so we can bootstrap the key vault with a placeholder secret if we want, so we later can update the secret with the actual private key. This way we avoid storing secrets in `terraform.tfstate/terraform.tfvars`.

## Resources created:
- Azure Key Vault
- A key vault access policy allowing the current user to set and get secrets
- A secret in the key vault, preferrably a placeholder.

## How to generate private and public keys
By running `wg genkey | tee wg_private.key | wg pubkey > wg_public.key` two sets of keys are written to your current folder. One consists of you private key and the other of your public key.

## Example `terraform.tfvars`
```
azure_tenant_id       = "some_tenant_id"
azure_subscription_id = "some_subscription_id"
azure_location        = "Norway East"
deployment_name       = "my-wireguard"

wireguard_private_key = "some_string" # This can be rotated later if you don't want your actual private key to be stored in the state file.
```