locals {
  wg_server_address           = cidrhost(var.wg_server_network_cidr, 1)
  wg_server_address_with_cidr = "${local.wg_server_address}/${split("/", var.wg_server_network_cidr)[1]}"
}

data "template_file" "wg_client_data_json" {
  for_each = var.wg_client_public_keys

  template = file("${path.module}/assets/client_data.tpl")

  vars = {
    user              = each.key
    client_public_key = each.value["public_key"]
    client_ip         = each.value["ip"]

    persistent_keepalive = var.wg_persistent_keepalive
  }
}

locals {
  peers_list = [for p in data.template_file.wg_client_data_json : p.rendered]
}

data "template_file" "user_data" {
  template = file("${path.module}/assets/user_data.tpl")

  vars = {
    wg_server_network_cidr      = var.wg_server_network_cidr
    wg_server_address           = local.wg_server_address
    wg_server_address_with_cidr = local.wg_server_address_with_cidr

    wg_server_port = var.wg_server_port

    peers = join("\n", local.peers_list)

    vm_identity_id = local.vm_identity_id
    vault_name     = data.azurerm_key_vault.main.name
    kv_secret_name = "wg-priv-key"
  }
}