resource "azurerm_express_route_gateway" "express_route_gateway" {

  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  scale_units         = var.scale_units
  virtual_hub_id      = var.virtual_hub_id
  tags                = try(var.tags, {})
}