# Create the Express Route Connection
resource "azurerm_express_route_connection" "er_connection" {
  express_route_circuit_peering_id = var.express_route_circuit_peering_id
  express_route_gateway_id         = var.express_route_gateway_id
  name                             = var.name
  authorization_key                = try(var.authorization_key, null)
  enable_internet_security         = try(var.enable_internet_security, null)
  routing_weight                   = try(var.routing_weight, null)

  dynamic "routing" {
    for_each = var.routing != null && length(var.routing) > 0 ? [var.routing] : []

    content {
      associated_route_table_id = routing.value.associated_route_table_id
      inbound_route_map_id      = try(routing.value.inbound_route_map_id, null)
      outbound_route_map_id     = try(routing.value.outbound_route_map_id, null)

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table != null ? [routing.value.propagated_route_table] : []

        content {
          labels          = try(propagated_route_tables.value.labels, [])
          route_table_ids = try(propagated_route_tables.value.route_table_ids, [])
        }
      }
    }
  }
}
