
resource "azurerm_virtual_hub" "virtual_hub" {
  for_each = var.virtual_hubs != null ? var.virtual_hubs : {}

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group
  address_prefix      = each.value.address_prefix
  tags                = each.value.tags
  virtual_wan_id      = each.value.virtual_wan_id

  hub_routing_preference                 = each.value.hub_routing_preference
  virtual_router_auto_scale_min_capacity = each.value.virtual_router_auto_scale_min_capacity
}
