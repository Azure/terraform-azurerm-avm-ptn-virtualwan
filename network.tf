# Virtual network connection from virtual hub
# Create a hub connection
resource "azurerm_virtual_hub_connection" "hub_connection" {
  for_each = local.virtual_network_connections

  name                      = each.value.name
  virtual_hub_id            = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_name].id
  remote_virtual_network_id = each.value.remote_virtual_network_id
  internet_security_enabled = each.value.internet_security_enabled
  dynamic "routing" {
    for_each = each.value.routing

    content {
      associated_route_table_id = routing.value.associated_route_table_id

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table

        content {
          route_table_ids = propagated_route_tables.value.route_table_ids
          labels          = propagated_route_tables.value.labels
        }
      }

      dynamic "static_vnet_route" {
        for_each = routing.value.static_vnet_route

        content {
          name                = static_vnet_route.value.name
          address_prefixes    = static_vnet_route.value.address_prefixes
          next_hop_ip_address = static_vnet_route.value.next_hop_ip_address
        }
      }
    }
  }
}

# Routing intent
resource "azurerm_virtual_hub_routing_intent" "routing_intent" {
  for_each       = local.routing_intents
  name           = each.value.name
  virtual_hub_id = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_name].id

  dynamic "routing_policy" {
    for_each = each.value.routing_policies
    content {
      name         = routing_policy.value.name
      destinations = routing_policy.value.destinations
      next_hop     = azurerm_firewall.fw[routing_policy.value.next_hop].id
    }
  }
}