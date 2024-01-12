# Point to site VPN Gateway
resource "azurerm_vpn_server_configuration" "p2s_gateway_vpn_server_configuration" {
  for_each = local.p2s_gateway_vpn_server_configurations != null && length(local.p2s_gateway_vpn_server_configurations) > 0 ? local.p2s_gateway_vpn_server_configurations : {}

  name                     = each.value.name
  location                 = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_map_key].location
  resource_group_name      = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_map_key].resource_group_name
  vpn_authentication_types = each.value.vpn_authentication_types
  tags                     = try(each.value.tags, {})

  client_root_certificate {
    name             = each.value.client_root_certificate.name
    public_cert_data = each.value.client_root_certificate.public_cert_data
  }
}

resource "azurerm_point_to_site_vpn_gateway" "p2s_gateway" {
  for_each = local.p2s_gateways != null && length(local.p2s_gateways) > 0 ? local.p2s_gateways : {}

  name                        = each.value.name
  location                    = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_map_key].location
  resource_group_name         = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_map_key].resource_group_name
  virtual_hub_id              = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_map_key].id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.p2s_gateway_vpn_server_configuration[each.value.p2s_gateway_vpn_server_configuration_name].id
  scale_unit                  = each.value.scale_unit
  tags                        = try(each.value.tags, {})
  connection_configuration {
    name = each.value.connection_configuration.name

    vpn_client_address_pool {
      address_prefixes = each.value.connection_configuration.vpn_client_address_pool.address_prefixes
    }
  }
}