locals {
  virtual_hub = {
    for key, vhub in var.virtual_hubs : key => {
      name           = vhub.name
      location       = vhub.location
      resource_group = try(vhub.resource_group, "")
      address_prefix = vhub.address_prefix
      tags           = try(vhub.tags, {})
    }
  }
  vpn_gateways = var.vpn_gateways != null ? {
    for key, gw in var.vpn_gateways : key => {
      name        = gw.name
      virtual_hub = gw.virtual_hub
    }
  } : null
  expressroute_gateways = var.expressroute_gateways != null ? {
    for key, gw in var.expressroute_gateways : key => {
      name        = gw.name
      virtual_hub = gw.virtual_hub
      scale_units = gw.scale_units
    }
  } : null
  p2s_gateways = var.p2s_gateways != null ? {
    for key, gw in var.p2s_gateways : key => {
      name                                      = gw.name
      virtual_hub_map_key                          = gw.virtual_hub_map_key
      scale_unit                                = gw.scale_unit
      connection_configuration                  = gw.connection_configuration
      p2s_gateway_vpn_server_configuration_name = gw.p2s_gateway_vpn_server_configuration_name
    }
  } : null
  p2s_gateway_vpn_server_configurations = var.p2s_gateway_vpn_server_configurations != null ? {
    for key, svr in var.p2s_gateway_vpn_server_configurations : key => {
      name                     = svr.name
      virtual_hub_map_key         = svr.virtual_hub_map_key
      vpn_authentication_types = svr.vpn_authentication_types
      client_root_certificate  = svr.client_root_certificate
    }
  } : null
  vpn_sites = var.vpn_sites != null ? {
    for key, site in var.vpn_sites : key => {
      name             = site.name
      virtual_hub_map_key = site.virtual_hub_map_key
      address_cidrs    = site.address_cidrs
      links            = site.links
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
  virtual_network_connections = var.virtual_network_connections != null ? {
    for key, vnet_conn in var.virtual_network_connections : key => {
      name                      = vnet_conn.name
      virtual_hub_map_key          = vnet_conn.virtual_hub_map_key
      remote_virtual_network_id = vnet_conn.remote_virtual_network_id
      internet_security_enabled = try(vnet_conn.internet_security_enabled, null)
      routing                   = try(vnet_conn.routing, {})
    }
  } : null
  # routing_intents = var.routing_intents != null ? {
  #   for key, intent in var.routing_intents : key => {
  #     type                      = intent.type
  #     name                      = intent.name
  #     virtual_hub_map_key          = intent.virtual_hub_map_key
  #     policy_name               = intent.policy_name
  #     policy_destinations       = intent.policy_destinations
  #     policy_nexthop            = intent.policy_nexthop
  #     remove_special_chars      = try(intent.remove_special_chars, null)
  #     location                  = try(intent.location, null)
  #     identity                  = try(intent.identity, null)
  #     tags                      = try(intent.tags, null)
  #     response_export_values    = try(intent.response_export_values, null)
  #     locks                     = try(intent.locks, null)
  #     ignore_casing             = try(intent.ignore_casing, null)
  #     ignore_missing_property   = try(intent.ignore_missing_property, null)
  #     schema_validation_enabled = try(intent.schema_validation_enabled, null)
  #   }
  # } : null
  routing_intents = var.routing_intents != null ? {
    for key, intent in var.routing_intents : key => {
      name             = intent.name
      virtual_hub_map_key = intent.virtual_hub_map_key
      routing_policies = intent.routing_policies
    }
  } : null
}
