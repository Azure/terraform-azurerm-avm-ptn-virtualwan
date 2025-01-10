# Create the Express Route Connection
resource "azurerm_express_route_connection" "er_connection" {
  for_each = var.er_circuit_connections != null && length(var.er_circuit_connections) > 0 ? var.er_circuit_connections : {}

  express_route_circuit_peering_id = each.value.express_route_circuit_peering_id
  express_route_gateway_id         = each.value.express_route_gateway_id
  name                             = each.value.name
  authorization_key                = try(each.value.authorization_key, null)
  enable_internet_security         = try(each.value.enable_internet_security, null)
  routing_weight                   = try(each.value.routing_weight, null)

  dynamic "routing" {
    for_each = each.value.routing != null ? [each.value.routing] : []

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
