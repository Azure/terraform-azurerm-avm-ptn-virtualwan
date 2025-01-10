# Virtual network connection from virtual hub
# Create a hub connection
module "virtual_network_connections" {
  source = "./modules/vnet-conn"

  virtual_network_connections = {
    for key, connection in var.virtual_network_connections : key => {
      name                      = connection.name
      virtual_hub_id            = module.virtual_hubs.resource_object[connection.virtual_hub_key].id
      remote_virtual_network_id = connection.remote_virtual_network_id
      internet_security_enabled = connection.internet_security_enabled
      routing = connection.routing != null ? {
        associated_route_table_id = connection.routing.associated_route_table_id
        propagated_route_table = connection.routing.propagated_route_table != null ? {
          route_table_ids = connection.routing.propagated_route_table.route_table_ids
          labels          = connection.routing.propagated_route_table.labels
        } : null
        static_vnet_route = connection.routing.static_vnet_route != null ? {
          name                = connection.routing.static_vnet_route.name
          address_prefixes    = connection.routing.static_vnet_route.address_prefixes
          next_hop_ip_address = connection.routing.static_vnet_route.next_hop_ip_address
        } : null
      } : null
    }
  }
}
# Routing intent
resource "azurerm_virtual_hub_routing_intent" "routing_intent" {
  for_each = local.routing_intents != null ? local.routing_intents : {}

  name           = each.value.name
  virtual_hub_id = module.virtual_hubs.resource_object[each.value.virtual_hub_key].id

  dynamic "routing_policy" {
    for_each = each.value.routing_policies

    content {
      destinations = routing_policy.value.destinations
      name         = routing_policy.value.name
      next_hop     = module.firewalls.resource_object[routing_policy.value.next_hop_firewall_key].id
    }
  }
}
