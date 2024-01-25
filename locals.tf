locals {
  er_circuit_connections = var.er_circuit_connections != null ? {
    for key, er_conn in var.er_circuit_connections : key => {
      name                                 = er_conn.name
      express_route_gateway_name           = er_conn.express_route_gateway_name
      express_route_circuit_peering_id     = er_conn.express_route_circuit_peering_id
      authorization_key                    = try(er_conn.authorization_key, null)
      enable_internet_security             = try(er_conn.enable_internet_security, null)
      express_route_gateway_bypass_enabled = try(er_conn.express_route_gateway_bypass_enabled, null)
      routing_weight                       = try(er_conn.routing_weight, null)
      routing                              = try(er_conn.routing, {})
    }
  } : null
  expressroute_gateways = var.expressroute_gateways != null ? {
    for key, gw in var.expressroute_gateways : key => {
      name        = gw.name
      virtual_hub = gw.virtual_hub
      scale_units = gw.scale_units
    }
  } : null
  p2s_gateway_vpn_server_configurations = var.p2s_gateway_vpn_server_configurations != null ? {
    for key, svr in var.p2s_gateway_vpn_server_configurations : key => {
      name                     = svr.name
      virtual_hub_name         = svr.virtual_hub_name
      vpn_authentication_types = svr.vpn_authentication_types
      client_root_certificate  = svr.client_root_certificate
    }
  } : null
  p2s_gateways = var.p2s_gateways != null ? {
    for key, gw in var.p2s_gateways : key => {
      name                                      = gw.name
      virtual_hub_name                          = gw.virtual_hub_name
      scale_unit                                = gw.scale_unit
      connection_configuration                  = gw.connection_configuration
      p2s_gateway_vpn_server_configuration_name = gw.p2s_gateway_vpn_server_configuration_name
    }
  } : null
  routing_intents = {
    for key, intent in var.routing_intents : key => {
      name             = intent.name
      virtual_hub_name = intent.virtual_hub_name
      routing_policies = lookup(intent, "routing_policies", null) == null ? [] : [{
        name         = intent.routing_policies.name
        destinations = intent.routing_policies.destinations
        next_hop     = intent.routing_policies.next_hop
      }]
    }
  }
  virtual_hub = {
    for key, vhub in var.virtual_hubs : key => {
      name           = vhub.name
      location       = vhub.location
      resource_group = try(vhub.resource_group, "")
      address_prefix = vhub.address_prefix
      tags           = try(vhub.tags, {})
    }
  }
  virtual_network_connections = {
    for key, vnet_conn in var.virtual_network_connections : key => {
      name                      = vnet_conn.name
      virtual_hub_name          = vnet_conn.virtual_hub_name
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
      name        = gw.name
      virtual_hub = gw.virtual_hub
    }
  } : null
  vpn_site_connections = var.vpn_site_connections != null ? {
    for key, conn in var.vpn_site_connections : key => {
      name                    = conn.name
      vpn_gateway_name        = conn.vpn_gateway_name
      remote_vpn_site_name    = conn.remote_vpn_site_name
      vpn_links               = conn.vpn_links
      routing                 = conn.routing
      traffic_selector_policy = conn.traffic_selector_policy
    }
  } : null
  vpn_sites = var.vpn_sites != null ? {
    for key, site in var.vpn_sites : key => {
      name             = site.name
      virtual_hub_name = site.virtual_hub_name
      address_cidrs    = site.address_cidrs
      links            = site.links
    }
  } : null
}
