# Create a vpn site. Sites represent the Physical locations (On-Premises) you wish to connect.
resource "azurerm_vpn_site" "vpn_site" {
  for_each = var.vpn_sites != null ? var.vpn_sites : {}

  location            = each.value.location
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  virtual_wan_id      = each.value.virtual_wan_id
  address_cidrs       = try(each.value.address_cidrs, null)
  device_model        = try(each.value.device_model, null)
  device_vendor       = try(each.value.device_vendor, null)
  tags                = try(each.value.tags, {})

  dynamic "link" {
    for_each = each.value.links != null && length(each.value.links) > 0 ? each.value.links : []

    content {
      name          = link.value.name
      fqdn          = try(link.value.fqdn, null)
      ip_address    = try(link.value.ip_address, null)
      provider_name = try(link.value.provider_name, null)
      speed_in_mbps = link.value.speed_in_mbps

      dynamic "bgp" {
        for_each = link.value.bgp != null ? [link.value.bgp] : []

        content {
          asn             = bgp.value.asn
          peering_address = bgp.value.peering_address
        }
      }
    }
  }
  dynamic "o365_policy" {
    for_each = each.value.o365_policy != null ? [each.value.o365_policy] : []

    content {
      traffic_category {
        allow_endpoint_enabled    = try(o365_policy.value.traffic_category.allow_endpoint_enabled, null)
        default_endpoint_enabled  = try(o365_policy.value.traffic_category.default_endpoint_enabled, null)
        optimize_endpoint_enabled = try(o365_policy.value.traffic_category.optimize_endpoint_enabled, null)
      }
    }
  }
}