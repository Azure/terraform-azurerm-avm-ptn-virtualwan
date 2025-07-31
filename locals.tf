locals {
  er_circuit_connections = var.er_circuit_connections != null ? {
    for key, er_conn in var.er_circuit_connections : key => {
      name                                 = er_conn.name
      express_route_gateway_key            = er_conn.express_route_gateway_key
      express_route_circuit_peering_id     = er_conn.express_route_circuit_peering_id
      authorization_key                    = try(er_conn.authorization_key, null)
      enable_internet_security             = try(er_conn.enable_internet_security, null)
      express_route_gateway_bypass_enabled = try(er_conn.express_route_gateway_bypass_enabled, null)
      routing_weight                       = try(er_conn.routing_weight, null)
      routing                              = try(er_conn.routing, null)
    }
  } : null
  expressroute_gateways = var.expressroute_gateways != null ? {
    for key, gw in var.expressroute_gateways : key => {
      name                          = gw.name
      virtual_hub_key               = gw.virtual_hub_key
      scale_units                   = gw.scale_units
      allow_non_virtual_wan_traffic = gw.allow_non_virtual_wan_traffic
      tags                          = try(gw.tags, null) == null ? var.tags : gw.tags
    }
  } : null
  p2s_gateway_vpn_server_configurations = var.p2s_gateway_vpn_server_configurations != null ? {
    for key, svr in var.p2s_gateway_vpn_server_configurations : key => {
      name                                  = svr.name
      virtual_hub_key                       = svr.virtual_hub_key
      vpn_authentication_types              = svr.vpn_authentication_types
      client_root_certificate               = svr.client_root_certificate
      azure_active_directory_authentication = svr.azure_active_directory_authentication
      tags                                  = try(svr.tags, null) == null ? var.tags : svr.tags
    }
  } : null
  p2s_gateways = var.p2s_gateways != null ? {
    for key, gw in var.p2s_gateways : key => {
      name                                     = gw.name
      virtual_hub_key                          = gw.virtual_hub_key
      scale_unit                               = gw.scale_unit
      connection_configuration                 = gw.connection_configuration
      p2s_gateway_vpn_server_configuration_key = gw.p2s_gateway_vpn_server_configuration_key
      tags                                     = try(gw.tags, null) == null ? var.tags : gw.tags
      dns_servers                              = gw.dns_servers
    }
  } : null
  routing_intents = {
    for key, intent in var.routing_intents : key => {
      name            = intent.name
      virtual_hub_key = intent.virtual_hub_key
      routing_policies = lookup(intent, "routing_policies", null) == null ? [] : [
        for routing_policy in intent.routing_policies : {
          name                  = routing_policy.name
          destinations          = routing_policy.destinations
          next_hop_firewall_key = routing_policy.next_hop_firewall_key
      }]
    }
  }
  virtual_hubs = {
    for key, vhub in var.virtual_hubs : key => {
      name                                   = vhub.name
      location                               = vhub.location
      resource_group                         = try(vhub.resource_group, "")
      address_prefix                         = vhub.address_prefix
      hub_routing_preference                 = try(vhub.hub_routing_preference, "")
      sku                                    = try(vhub.sku, null)
      tags                                   = try(vhub.tags, null) == null ? var.tags : vhub.tags
      virtual_router_auto_scale_min_capacity = vhub.virtual_router_auto_scale_min_capacity
    }
  }
  vpn_gateways = var.vpn_gateways != null ? {
    for key, gw in var.vpn_gateways : key => {
      name                                  = gw.name
      virtual_hub_key                       = gw.virtual_hub_key
      bgp_route_translation_for_nat_enabled = gw.bgp_route_translation_for_nat_enabled
      bgp_settings                          = gw.bgp_settings
      routing_preference                    = gw.routing_preference
      scale_unit                            = gw.scale_unit
      tags                                  = try(gw.tags, null) == null ? var.tags : gw.tags
    }
  } : null
  vpn_site_connections = var.vpn_site_connections != null ? {
    for key, conn in var.vpn_site_connections : key => {
      name                      = conn.name
      vpn_gateway_key           = conn.vpn_gateway_key
      remote_vpn_site_key       = conn.remote_vpn_site_key
      internet_security_enabled = conn.internet_security_enabled
      vpn_links                 = conn.vpn_links
      routing                   = conn.routing
      traffic_selector_policy   = conn.traffic_selector_policy
    }
  } : null
  vpn_sites = var.vpn_sites != null ? {
    for key, site in var.vpn_sites : key => {
      name            = site.name
      virtual_hub_key = site.virtual_hub_key
      address_cidrs   = site.address_cidrs
      links           = site.links
      device_vendor   = site.device_vendor
      device_model    = site.device_model
      o365_policy     = site.o365_policy
      tags            = try(site.tags, null) == null ? var.tags : site.tags
    }
  } : null
}
