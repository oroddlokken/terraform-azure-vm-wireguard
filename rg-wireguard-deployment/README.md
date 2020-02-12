# Terraform deployment for VMs with WireGuard on Microsoft Azure

## Example `terraform.tfvars`
```
azure_tenant_id       = "some_tenant_id"
azure_subscription_id = "some_subscription_id"
azure_location        = "Norway East"
deployment_name       = "my-wireguard"

# VM
vm_public_ssh_key = "my-ssh-key"

# VNet
mgmt_allowed_hosts = [
  "8.8.8.8/32"
]

# WireGuard
wg_client_public_keys = {
  "user1-desktop" = {
    "ip"         = "192.168.2.2/32"
    "public_key" = "cdcdcdcdcdcdcdcd"
  }
  "user1-phone" = {
    "ip"         = "192.168.2.3/32"
    "public_key" = "abababababababa"
  }
}
```