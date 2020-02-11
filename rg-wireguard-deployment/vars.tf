variable azure_tenant_id {}
variable azure_subscription_id {}

variable azure_location {}

variable deployment_name {}

variable tags {
  type = map
}

variable vm_username {
  default = "ubuntu"
}

variable vm_public_ssh_key {
}

variable vnet_cidr {
  default = "10.25.0.0/16"
}

variable vnet_default_subnet_cidr {
  default = "10.25.0.0/24"
}

variable vm_size {
  default = "Standard_B1ls"
}

variable mgmt_allowed_hosts {
  type        = list
  description = "A list of hosts/networks to open up SSH access to."
}

variable sg_wg_allowed_subnets {
  type        = list
  description = "A list of hosts/networks to open up WireGuard access to."
  default     = ["0.0.0.0/0"]
}

# WireGuard
variable wg_client_public_keys {
  type        = map(map(string))
  description = "List of maps of client IPs and public keys. See Usage in README for details."
}

variable "wg_persistent_keepalive" {
  type        = number
  description = "Persistent Keepalive - useful for helping connectiona stability over NATs"
  default     = 25
}

variable wg_server_network_cidr {
  type        = string
  description = "The internal network to use for WireGuard. Remember to place the clients in the same subnet."
  default     = "192.168.2.0/24"
}

variable "wg_server_port" {
  type        = number
  description = "The port WireGuard should listen on."
  default     = 51820
}