resource "azurerm_vpn_gateway" "vpn_gateway" {
  location                              = var.location
  name                                  = var.name
  resource_group_name                   = var.resource_group_name
  virtual_hub_id                        = var.virtual_hub_id
  bgp_route_translation_for_nat_enabled = try(var.bgp_route_translation_for_nat_enabled, false)
  routing_preference                    = try(var.routing_preference, null)
  scale_unit                            = try(var.scale_unit, null)
  tags                                  = try(var.tags, {})

  dynamic "bgp_settings" {
    for_each = var.bgp_settings != null ? [var.bgp_settings] : []

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