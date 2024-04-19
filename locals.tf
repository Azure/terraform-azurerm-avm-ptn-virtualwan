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
      name            = gw.name
      virtual_hub_key = gw.virtual_hub_key
      scale_units     = gw.scale_units
    }
  } : null
  p2s_gateway_vpn_server_configurations = var.p2s_gateway_vpn_server_configurations != null ? {
    for key, svr in var.p2s_gateway_vpn_server_configurations : key => {
      name                     = svr.name
      virtual_hub_key          = svr.virtual_hub_key
      vpn_authentication_types = svr.vpn_authentication_types
      client_root_certificate  = svr.client_root_certificate
    }
  } : null
  p2s_gateways = var.p2s_gateways != null ? {
    for key, gw in var.p2s_gateways : key => {
      name                                     = gw.name
      virtual_hub_key                          = gw.virtual_hub_key
      scale_unit                               = gw.scale_unit
      connection_configuration                 = gw.connection_configuration
      p2s_gateway_vpn_server_configuration_key = gw.p2s_gateway_vpn_server_configuration_key
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
      name                   = vhub.name
      location               = vhub.location
      resource_group         = try(vhub.resource_group, "")
      address_prefix         = vhub.address_prefix
      hub_routing_preference = try(vhub.hub_routing_preference, "")
      tags                   = try(vhub.tags, {})
    }
  }
  virtual_network_connections = {
    for key, vnet_conn in var.virtual_network_connections : key => {
      name                      = vnet_conn.name
      virtual_hub_key           = vnet_conn.virtual_hub_key
      remote_virtual_network_id = vnet_conn.remote_virtual_network_id
      internet_security_enabled = vnet_conn.internet_security_enabled
      routing = lookup(vnet_conn, "routing", null) == null ? [] : [{
        associated_route_table_id = vnet_conn.routing.associated_route_table_id
        propagated_route_table = lookup(vnet_conn.routing, "propagated_route_table", null) == null ? [] : [{
          route_table_ids = vnet_conn.routing.propagated_route_table.route_table_ids
          labels          = vnet_conn.routing.propagated_route_table.labels
        }]
        static_vnet_route = lookup(vnet_conn, "static_vnet_route", null) == null ? [] : [{
          name                = vnet_conn.routing.static_vnet_route.name
          address_prefixes    = vnet_conn.routing.static_vnet_route.address_prefixes
          next_hop_ip_address = vnet_conn.routing.static_vnet_route.next_hop_ip_address
        }]
      }]
    }
  }
  vpn_gateways = var.vpn_gateways != null ? {
    for key, gw in var.vpn_gateways : key => {
      name            = gw.name
      virtual_hub_key = gw.virtual_hub_key
    }
  } : null
  vpn_site_connections = var.vpn_site_connections != null ? {
    for key, conn in var.vpn_site_connections : key => {
      name                    = conn.name
      vpn_gateway_key         = conn.vpn_gateway_key
      remote_vpn_site_key     = conn.remote_vpn_site_key
      vpn_links               = conn.vpn_links
      routing                 = conn.routing
      traffic_selector_policy = conn.traffic_selector_policy
    }
  } : null
  vpn_sites = var.vpn_sites != null ? {
    for key, site in var.vpn_sites : key => {
      name            = site.name
      virtual_hub_key = site.virtual_hub_key
      address_cidrs   = site.address_cidrs
      links           = site.links
    }
  } : null
}
