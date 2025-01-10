module "express_route_gateways" {
  source = "./modules/expressroute-gateway"

  expressroute_gateways = {
    for key, gw in local.expressroute_gateways : key => {
      name                          = gw.name
      resource_group_name           = module.virtual_hubs.resource_object[gw.virtual_hub_key].resource_group
      virtual_hub_id                = module.virtual_hubs.resource_object[gw.virtual_hub_key].id
      location                      = module.virtual_hubs.resource_object[gw.virtual_hub_key].location
      scale_units                   = gw.scale_units
      allow_non_virtual_wan_traffic = gw.allow_non_virtual_wan_traffic
      tags                          = try(gw.tags, {})
    }
  }
}

moved {
  from = azurerm_express_route_gateway.express_route_gateway
  to   = module.express_route_gateways.azurerm_express_route_gateway.express_route_gateway
}


# Create the Express Route Connection
module "er_connections" {
  source = "./modules/expressroute-gateway-conn"

  er_circuit_connections = {
    for key, conn in local.er_circuit_connections : key => {
      name                                 = conn.name
      express_route_gateway_id             = module.express_route_gateways.resource_object[conn.express_route_gateway_key].id
      express_route_circuit_peering_id     = conn.express_route_circuit_peering_id
      authorization_key                    = try(conn.authorization_key, null)
      enable_internet_security             = try(conn.enable_internet_security, null)
      express_route_gateway_bypass_enabled = try(conn.express_route_gateway_bypass_enabled, null)
      routing                              = try(conn.routing, null)
      routing_weight                       = try(conn.routing_weight, null)
    }
  }
}

moved {
  from = azurerm_express_route_connection.er_connection
  to   = module.er_connections.azurerm_express_route_connection.er_connection
}
