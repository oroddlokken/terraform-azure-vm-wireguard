# Azure WireGuard deployment

This Terraform deployment sets up a WireGuard server in Azure, along with all the prerequesites. To avoid storing the WireGuard private key in `terraform.tfstate/terraform.tfvars` we store it as a secret in Azure Key Vault.

This is a different from my other Terraform deployment [oroddlokken/terraform-aws-ec2-wireguard](https://github.com/oroddlokken/terraform-aws-ec2-wireguard) in that it is a two-step deployment. First we create a resource group with the key-vault containing our WireGuard private key, and then in our second deployment we create the VM, VNet, etc.

I work with AWS on a day-to-day basis and I almost never use Azure any more, so this project is a way for me to learn more about how the different clouds differ from each other when you get involved with concepsts such as IAM or secrets management.

The two deployments expects the `deployment_name` variable value to stay identical, as we do a data source lookup based on that name.