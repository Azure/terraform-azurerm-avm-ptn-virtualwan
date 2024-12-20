
resource "azurerm_virtual_hub" "virtual_hub" {
  location               = var.location
  name                   = var.name
  resource_group_name    = var.resource_group_name
  address_prefix         = var.address_prefix
  hub_routing_preference = var.hub_routing_preference
  tags                   = try(var.tags, {})
  virtual_wan_id         = var.virtual_wan_id
}
