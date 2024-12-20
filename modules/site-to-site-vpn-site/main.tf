# Create a vpn site. Sites represent the Physical locations (On-Premises) you wish to connect.
resource "azurerm_vpn_site" "vpn_site" {
  location            = var.vpn_sites.location
  name                = var.vpn_sites.name
  resource_group_name = var.vpn_sites.resource_group_name
  virtual_wan_id      = var.vpn_sites.virtual_wan_id
  address_cidrs       = try(var.vpn_sites.address_cidrs, null)
  device_model        = try(var.vpn_sites.device_model, null)
  device_vendor       = try(var.vpn_sites.device_vendor, null)
  tags                = try(var.vpn_sites.tags, {})

  dynamic "link" {
    for_each = var.vpn_sites.links != null && length(var.vpn_sites.links) > 0 ? var.vpn_sites.links : []

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
    for_each = var.vpn_sites.o365_policy != null ? [var.vpn_sites.o365_policy] : []

    content {
      traffic_category {
        allow_endpoint_enabled    = try(o365_policy.value.traffic_category.allow_endpoint_enabled, null)
        default_endpoint_enabled  = try(o365_policy.value.traffic_category.default_endpoint_enabled, null)
        optimize_endpoint_enabled = try(o365_policy.value.traffic_category.optimize_endpoint_enabled, null)
      }
    }
  }
}