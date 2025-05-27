# Create the Express Route Connection
locals {
  azurerm_express_route_connection_set = toset(try(nonsensitive(keys(var.er_circuit_connections)), []))
}

resource "azurerm_express_route_connection" "er_connection" {
  for_each = local.azurerm_express_route_connection_set

  express_route_circuit_peering_id = var.er_circuit_connections[each.key].express_route_circuit_peering_id
  express_route_gateway_id         = var.er_circuit_connections[each.key].express_route_gateway_id
  name                             = var.er_circuit_connections[each.key].name
  authorization_key                = try(var.er_circuit_connections[each.key].authorization_key, null)
  enable_internet_security         = try(var.er_circuit_connections[each.key].enable_internet_security, null)
  routing_weight                   = try(var.er_circuit_connections[each.key].routing_weight, null)

  dynamic "routing" {
    for_each = var.er_circuit_connections[each.key].routing != null ? [var.er_circuit_connections[each.key].routing] : []

    content {
      associated_route_table_id = routing.value.associated_route_table_id
      inbound_route_map_id      = try(routing.value.inbound_route_map_id, null)
      outbound_route_map_id     = try(routing.value.outbound_route_map_id, null)

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table != null ? [routing.value.propagated_route_table] : []

        content {
          labels          = try(propagated_route_table.value.labels, [])
          route_table_ids = try(propagated_route_table.value.route_table_ids, [])
        }
      }
    }
  }
}
