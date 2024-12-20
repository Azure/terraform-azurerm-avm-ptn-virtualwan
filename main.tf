data "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 0 : 1

  name = var.resource_group_name
}

# Create rgs as defined by var.virtual_wan
resource "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 1 : 0

  location = var.location
  name     = var.resource_group_name
  tags     = try(merge(var.resource_group_tags, var.tags), {})
}

locals {
  resource_group_name = var.create_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.rg[0].name
}

resource "azurerm_virtual_wan" "virtual_wan" {
  location                          = var.location
  name                              = var.virtual_wan_name
  resource_group_name               = local.resource_group_name
  allow_branch_to_branch_traffic    = try(var.allow_branch_to_branch_traffic, true)
  disable_vpn_encryption            = var.disable_vpn_encryption ? false : true
  office365_local_breakout_category = try(var.office365_local_breakout_category, "None")
  tags                              = merge(var.tags, var.virtual_wan_tags)
  type                              = var.type
}

module "virtual_hubs" {
  source = "./modules/virtualhub"

  for_each = local.virtual_hubs != null && length(local.virtual_hubs) > 0 ? local.virtual_hubs : {}

  location               = each.value.location
  name                   = each.value.name
  resource_group_name    = coalesce(each.value.resource_group, local.resource_group_name)
  address_prefix         = each.value.address_prefix
  hub_routing_preference = each.value.hub_routing_preference
  tags                   = try(each.value.tags, {})
  virtual_wan_id         = azurerm_virtual_wan.virtual_wan.id

}