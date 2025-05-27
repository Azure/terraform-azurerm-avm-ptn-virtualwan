# Virtual network connection from virtual hub
# Create a hub connection
module "virtual_network_connections" {
  source = "./modules/vnet-conn"

  virtual_network_connections = {
    for key, vnet_conn in var.virtual_network_connections : key => {
      name                      = vnet_conn.name
      virtual_hub_id            = module.virtual_hubs.resource_id[vnet_conn.virtual_hub_key]
      remote_virtual_network_id = vnet_conn.remote_virtual_network_id
      internet_security_enabled = lookup(vnet_conn, "internet_security_enabled", false)
      routing = lookup(vnet_conn, "routing", null) == null ? null : {
        associated_route_table_id = vnet_conn.routing.associated_route_table_id
        propagated_route_table = lookup(vnet_conn.routing, "propagated_route_table", null) == null ? null : {
          route_table_ids = lookup(vnet_conn.routing.propagated_route_table, "route_table_ids", [])
          labels          = lookup(vnet_conn.routing.propagated_route_table, "labels", [])
        }
        static_vnet_route = lookup(vnet_conn.routing, "static_vnet_route", null) == null ? null : {
          name                = lookup(vnet_conn.routing.static_vnet_route, "name", null)
          address_prefixes    = lookup(vnet_conn.routing.static_vnet_route, "address_prefixes", [])
          next_hop_ip_address = lookup(vnet_conn.routing.static_vnet_route, "next_hop_ip_address", null)
        }
      }
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
