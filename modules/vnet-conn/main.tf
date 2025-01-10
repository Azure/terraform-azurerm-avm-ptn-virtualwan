resource "azurerm_virtual_hub_connection" "hub_connection" {
  for_each = var.virtual_network_connections != null ? var.virtual_network_connections : {}

  name                      = each.value.name
  remote_virtual_network_id = each.value.remote_virtual_network_id
  virtual_hub_id            = each.value.virtual_hub_id
  internet_security_enabled = each.value.internet_security_enabled

  dynamic "routing" {
    for_each = each.value.routing != null ? [each.value.routing] : []

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