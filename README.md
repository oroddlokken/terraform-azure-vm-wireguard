# Azure WireGuard deployment

This Terraform deployment sets up a WireGuard server in Azure, along with all the prerequesites. To avoid storing the WireGuard private key in `terraform.tfstate/terraform.tfvars` we store it as a secret in Azure Key Vault.

This is a different from my other Terraform deployment `[oroddlokken/terraform-aws-ec2-wireguard](https://github.com/oroddlokken/terraform-aws-ec2-wireguard)` in that it is a two-step deployment. First we create a resource group with they key-vault, and then in our second deployment we create the VM.

I work with AWS on a day-to-day basis and I almost never use Azure any more, so this project is for me to learn more about how the two cloud differ from each other.

The two deployments expects the `deployment_name` variable value to be the same, as we do data source lookups based on that.