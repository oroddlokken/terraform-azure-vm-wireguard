# Terraform deployment for VMs with WireGuard on Microsoft Azure

This deployment sets up a VM in Azure running WireGuard, along with a VNet, a subnet, NIC, storage accounts, etc.

## Resources created:
- VNet
- A subnet
- A public IP
- A NIC for the VM
- A VM
- A storage account for boot diagnostics
- A user assigned identity for the VM
- IAM policies for the VM identity

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