resource "azurerm_express_route_gateway" "express_route_gateway" {
  for_each = local.expressroute_gateways != null && length(local.expressroute_gateways) > 0 ? local.expressroute_gateways : {}

  location            = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_key].location
  name                = each.value.name
  resource_group_name = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_key].resource_group_name
  scale_units         = each.value.scale_units
  virtual_hub_id      = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_key].id
  tags                = try(each.value.tags, {})
}


# Create the Express Route Connection
resource "azurerm_express_route_connection" "er_connection" {
  for_each = local.er_circuit_connections != null && length(local.er_circuit_connections) > 0 ? local.er_circuit_connections : {}

  express_route_circuit_peering_id = each.value.er_circuit_peering_id
  express_route_gateway_id         = azurerm_express_route_gateway.express_route_gateway[each.value.express_route_gateway_name].id
  name                             = each.value.name
  authorization_key                = try(each.value.authorization_key, null)
  enable_internet_security         = try(each.value.enable_internet_security, null)
  routing_weight                   = try(each.value.routing_weight, null)

  dynamic "routing" {
    for_each = each.value.routing != null && length(each.value.routing) > 0 ? [each.value.routing] : []
    content {
      associated_route_table_id = routing.value.associated_route_table_id
      inbound_route_map_id      = try(routing.value.inbound_route_map_id, null)
      outbound_route_map_id     = try(routing.value.outbound_route_map_id, null)

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table != null && length(routing.value.propagated_route_table) > 0 ? [routing.value.propagated_route_table] : []
        content {
          labels          = try(propagated_route_tables.value.labels, [])
          route_table_ids = try(propagated_route_tables.value.route_table_ids, [])
        }
      }
    }
  }
}
