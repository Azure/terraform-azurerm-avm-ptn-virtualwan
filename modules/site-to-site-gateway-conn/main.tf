# Create a site to site vpn connection between a vpn gateway and a vpn site.
locals {
  azurerm_vpn_gateway_connection_set = toset(try(nonsensitive(keys(var.vpn_site_connection)), []))
}

resource "azurerm_vpn_gateway_connection" "vpn_site_connection" {
  for_each = local.azurerm_vpn_gateway_connection_set

  name                      = var.vpn_site_connection[each.key].name
  remote_vpn_site_id        = var.vpn_site_connection[each.key].remote_vpn_site_id
  vpn_gateway_id            = var.vpn_site_connection[each.key].vpn_gateway_id
  internet_security_enabled = try(var.vpn_site_connection[each.key].internet_security_enabled, null)

  dynamic "vpn_link" {
    for_each = var.vpn_site_connection[each.key].vpn_links != null && length(var.vpn_site_connection[each.key].vpn_links) > 0 ? var.vpn_site_connection[each.key].vpn_links : []

    content {
      name                                  = vpn_link.value.name
      vpn_site_link_id                      = vpn_link.value.vpn_site_link_id
      bandwidth_mbps                        = try(vpn_link.value.bandwidth_mbps, null)
      bgp_enabled                           = try(vpn_link.value.bgp_enabled, null)
      connection_mode                       = try(vpn_link.value.connection_mode, null)
      egress_nat_rule_ids                   = try(vpn_link.value.egress_nat_rule_ids, null)
      ingress_nat_rule_ids                  = try(vpn_link.value.ingress_nat_rule_ids, null)
      local_azure_ip_address_enabled        = try(vpn_link.value.local_azure_ip_address_enabled, null)
      policy_based_traffic_selector_enabled = try(vpn_link.value.policy_based_traffic_selector_enabled, null)
      protocol                              = try(vpn_link.value.protocol, null)
      ratelimit_enabled                     = try(vpn_link.value.ratelimit_enabled, null)
      route_weight                          = try(vpn_link.value.route_weight, null)
      shared_key                            = try(vpn_link.value.shared_key, null)

      dynamic "custom_bgp_address" {
        for_each = vpn_link.value.custom_bgp_addresses != null ? vpn_link.value.custom_bgp_addresses : []

        content {
          ip_address          = custom_bgp_address.value.ip_address
          ip_configuration_id = custom_bgp_address.value.ip_configuration_id
        }
      }
      dynamic "ipsec_policy" {
        for_each = vpn_link.value.ipsec_policy != null ? [vpn_link.value.ipsec_policy] : []

        content {
          dh_group                 = ipsec_policy.value.dh_group
          encryption_algorithm     = ipsec_policy.value.encryption_algorithm
          ike_encryption_algorithm = ipsec_policy.value.ike_encryption_algorithm
          ike_integrity_algorithm  = ipsec_policy.value.ike_integrity_algorithm
          integrity_algorithm      = ipsec_policy.value.integrity_algorithm
          pfs_group                = ipsec_policy.value.pfs_group
          sa_data_size_kb          = ipsec_policy.value.sa_data_size_kb
          sa_lifetime_sec          = ipsec_policy.value.sa_lifetime_sec
        }
      }
    }
  }
  dynamic "routing" {
    for_each = var.vpn_site_connection[each.key].routing != null ? [var.vpn_site_connection[each.key].routing] : []

    content {
      associated_route_table = routing.value.associated_route_table

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table != null ? [routing.value.propagated_route_table] : []

        content {
          route_table_ids = propagated_route_table.value.route_table_ids
          labels          = propagated_route_table.value.labels
        }
      }
    }
  }
  dynamic "traffic_selector_policy" {
    for_each = var.vpn_site_connection[each.key].traffic_selector_policy != null ? [var.vpn_site_connection[each.key].traffic_selector_policy] : []

    content {
      local_address_ranges  = traffic_selector_policy.value.local_address_ranges
      remote_address_ranges = traffic_selector_policy.value.remote_address_ranges
    }
  }
}

