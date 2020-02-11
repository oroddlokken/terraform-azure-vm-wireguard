resource "azurerm_public_ip" "main" {
  name                = "pip-${var.deployment_name}"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_network_interface" "main" {
  name                = "nic-${var.deployment_name}"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "default"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_virtual_machine" "main" {
  name                = "vm-${var.deployment_name}"
  location            = var.azure_location
  resource_group_name = azurerm_resource_group.main.name

  network_interface_ids = ["${azurerm_network_interface.main.id}"]

  vm_size = var.vm_size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "stvm-${var.deployment_name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

  os_profile {
    computer_name  = var.deployment_name
    admin_username = var.vm_username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = var.vm_public_ssh_key
      path     = "/home/${var.vm_username}/.ssh/authorized_keys"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.bootdiag.primary_blob_endpoint
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      local.vm_identity_id
    ]
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      vm_size
    ]
  }
}
