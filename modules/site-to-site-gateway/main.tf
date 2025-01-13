resource "azurerm_vpn_gateway" "vpn_gateway" {
  for_each = var.vpn_gateways != null ? var.vpn_gateways : {}

  location                              = each.value.location
  name                                  = each.value.name
  resource_group_name                   = each.value.resource_group_name
  virtual_hub_id                        = each.value.virtual_hub_id
  bgp_route_translation_for_nat_enabled = try(each.value.bgp_route_translation_for_nat_enabled, false)
  routing_preference                    = try(each.value.routing_preference, null)
  scale_unit                            = try(each.value.scale_unit, null)
  tags                                  = try(each.value.tags, {})

  dynamic "bgp_settings" {
    for_each = each.value.bgp_settings != null ? [each.value.bgp_settings] : []

    content {
      asn         = bgp_settings.value.asn
      peer_weight = bgp_settings.value.peer_weight

      dynamic "instance_0_bgp_peering_address" {
        for_each = bgp_settings.value.instance_0_bgp_peering_address != null ? [bgp_settings.value.instance_0_bgp_peering_address] : []

        content {
          custom_ips = try(instance_0_bgp_peering_address.value.custom_ips, null)
        }
      }
      dynamic "instance_1_bgp_peering_address" {
        for_each = bgp_settings.value.instance_1_bgp_peering_address != null ? [bgp_settings.value.instance_1_bgp_peering_address] : []

        content {
          custom_ips = try(instance_1_bgp_peering_address.value.custom_ips, null)
        }
      }
    }
  }
}