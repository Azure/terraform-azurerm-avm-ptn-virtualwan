resource "azurerm_express_route_gateway" "express_route_gateway" {
  for_each = var.expressroute_gateways != null && length(var.expressroute_gateways) > 0 ? var.expressroute_gateways : {}

  location                      = each.value.location
  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  scale_units                   = each.value.scale_units
  virtual_hub_id                = each.value.virtual_hub_id
  allow_non_virtual_wan_traffic = each.value.allow_non_virtual_wan_traffic
  tags                          = try(each.value.tags, {})
}