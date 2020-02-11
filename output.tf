output vpn_node_public_ip {
  description = "The public IP of the EC2 instance."
  value       = azurerm_public_ip.main.ip_address
}