
resource "azurerm_virtual_hub" "virtual_hub" {
  for_each = var.virtual_hubs != null ? var.virtual_hubs : {}

  location                               = each.value.location
  name                                   = each.value.name
  resource_group_name                    = each.value.resource_group
  address_prefix                         = each.value.address_prefix
  hub_routing_preference                 = each.value.hub_routing_preference
  tags                                   = each.value.tags
  virtual_router_auto_scale_min_capacity = each.value.virtual_router_auto_scale_min_capacity
  virtual_wan_id                         = each.value.virtual_wan_id
}
