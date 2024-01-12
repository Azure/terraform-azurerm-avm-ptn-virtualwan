# Virtual network connection from virtual hub
# Create a hub connection
resource "azurerm_virtual_hub_connection" "hub_connection" {
  for_each = local.virtual_network_connections != null && length(local.virtual_network_connections) > 0 ? local.virtual_network_connections : {}

  name                      = each.value.name
  virtual_hub_id            = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_map_key].id
  remote_virtual_network_id = each.value.remote_virtual_network_id
  internet_security_enabled = try(each.value.internet_security_enabled, null)
  dynamic "routing" {
    for_each = each.value.routing != null && length(each.value.routing) > 0 ? each.value.routing : []

    content {
      associated_route_table_id = try(routing.value.associated_route_table_id, null)

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table != null && length(routing.value.propagated_route_table) > 0 ? routing.value.propagated_route_table : []

        content {
          route_table_ids = try(propagated_route_tables.value.route_table_ids, [])
          labels          = try(propagated_route_tables.value.labels, [])
        }
      }

      dynamic "static_vnet_route" {
        for_each = routing.value.static_vnet_route != null && length(routing.value.static_vnet_route) > 0 ? routing.value.static_vnet_route : []

        content {
          name                = try(static_vnet_route.value.name, null)
          address_prefixes    = try(static_vnet_route.value.address_prefixes, [])
          next_hop_ip_address = try(static_vnet_route.value.next_hop_ip_address, null)
        }
      }
    }
  }
}

# Routing intent
resource "azurerm_virtual_hub_routing_intent" "routing_intent" {
  for_each       = local.routing_intents != null && length(local.routing_intents) > 0 ? local.routing_intents : {}
  name           = each.value.name
  virtual_hub_id = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_map_key].id

  dynamic "routing_policy" {
    for_each = each.value.routing_policies != null && length(each.value.routing_policies) > 0 ? each.value.routing_policies : []
    content {
      name         = routing_policy.value.name
      destinations = routing_policy.value.destinations
      next_hop     = azurerm_firewall.fw[routing_policy.value.next_hop].id
    }
  }
}