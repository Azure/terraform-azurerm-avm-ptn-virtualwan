module "express_route_gateways" {
  source = "./modules/expressroute-gateway"

  for_each = local.expressroute_gateways != null && length(local.expressroute_gateways) > 0 ? local.expressroute_gateways : {}


  location            = module.virtual_hubs[each.value.virtual_hub_key].location
  name                = each.value.name
  resource_group_name = module.virtual_hubs[each.value.virtual_hub_key].resource_group_name
  scale_units         = each.value.scale_units
  virtual_hub_id      = module.virtual_hubs[each.value.virtual_hub_key].resource_id
  tags                = try(each.value.tags, {})
}

moved {
  from = azurerm_express_route_gateway.express_route_gateway
  to   = module.express_route_gateways.azurerm_express_route_gateway.express_route_gateway
}


# Create the Express Route Connection
module "er_connections" {
  source   = "./modules/expressroute-gateway-conn"
  for_each = local.er_circuit_connections != null && length(local.er_circuit_connections) > 0 ? local.er_circuit_connections : {}

  express_route_circuit_peering_id = each.value.express_route_circuit_peering_id
  express_route_gateway_id         = module.express_route_gateways[each.value.express_route_gateway_key].resource_id
  name                             = each.value.name
  authorization_key                = try(each.value.authorization_key, null)
  enable_internet_security         = try(each.value.enable_internet_security, null)
  routing_weight                   = try(each.value.routing_weight, null)
  routing                          = try(each.value.routing, [])
}

moved {
  from = azurerm_express_route_connection.er_connection
  to   = module.er_connections.azurerm_express_route_connection.er_connection
}