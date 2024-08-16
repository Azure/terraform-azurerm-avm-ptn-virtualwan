# Virtual network connection from virtual hub
# Create a hub connection
resource "azurerm_virtual_hub_connection" "hub_connection" {
  for_each = local.virtual_network_connections

  name                      = each.value.name
  remote_virtual_network_id = each.value.remote_virtual_network_id
  virtual_hub_id            = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_key].id
  internet_security_enabled = each.value.internet_security_enabled

  dynamic "routing" {
    for_each = each.value.routing

    content {
      associated_route_table_id = routing.value.associated_route_table_id

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table

        content {
          labels          = propagated_route_table.value.labels
          route_table_ids = propagated_route_table.value.route_table_ids
        }
      }
      dynamic "static_vnet_route" {
        for_each = routing.value.static_vnet_route

        content {
          address_prefixes    = static_vnet_route.value.address_prefixes
          name                = static_vnet_route.value.name
          next_hop_ip_address = static_vnet_route.value.next_hop_ip_address
        }
      }
    }
  }
}

# Routing intent
resource "azurerm_virtual_hub_routing_intent" "routing_intent" {
  for_each = local.routing_intents

  name           = each.value.name
  virtual_hub_id = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_key].id

  dynamic "routing_policy" {
    for_each = each.value.routing_policies
    content {
      destinations = routing_policy.value.destinations
      name         = routing_policy.value.name
      next_hop     = azurerm_firewall.fw[routing_policy.value.next_hop_firewall_key].id
    }
  }
}