resource "azurerm_network_security_group" "main" {
  name = "nsg-${var.deployment_name}"

  location            = var.azure_location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_network_security_rule" "ssh" {
  count = length(var.mgmt_allowed_hosts)

  name     = "ssh-${count.index}"
  priority = 100 + count.index

  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range     = "*"
  source_address_prefix = element(var.mgmt_allowed_hosts, count.index)

  destination_address_prefix = "*"
  destination_port_range     = "22"

  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}


resource "azurerm_network_security_rule" "wireguard" {
  count = length(var.mgmt_allowed_hosts)

  name     = "wireguard-${count.index}"
  priority = 200 + count.index

  direction = "Inbound"
  access    = "Allow"
  protocol  = "Udp"

  source_port_range     = "*"
  source_address_prefix = element(var.sg_wg_allowed_subnets, count.index)

  destination_address_prefix = "*"
  destination_port_range     = var.wg_server_port

  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}
