resource "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 1 : 0

  location = var.location
  name     = var.resource_group_name
  tags     = try(merge(var.resource_group_tags, var.tags), var.tags)
}

locals {
  resource_group_name = var.create_resource_group ? azurerm_resource_group.rg[0].name : var.resource_group_name
}

resource "azurerm_virtual_wan" "virtual_wan" {
  location                          = var.location
  name                              = var.virtual_wan_name
  resource_group_name               = local.resource_group_name
  allow_branch_to_branch_traffic    = var.allow_branch_to_branch_traffic
  disable_vpn_encryption            = var.disable_vpn_encryption
  office365_local_breakout_category = var.office365_local_breakout_category
  tags                              = merge(var.tags, var.virtual_wan_tags)
  type                              = var.type
}

module "virtual_hubs" {
  source = "./modules/virtualhub"

  virtual_hubs = {
    for key, value in local.virtual_hubs : key => {
      name                                   = value.name
      location                               = value.location
      resource_group                         = value.resource_group
      address_prefix                         = value.address_prefix
      virtual_wan_id                         = azurerm_virtual_wan.virtual_wan.id
      hub_routing_preference                 = value.hub_routing_preference
      sku                                    = value.sku
      tags                                   = value.tags
      virtual_router_auto_scale_min_capacity = value.virtual_router_auto_scale_min_capacity
    }
  }
}

moved {
  from = azurerm_virtual_hub.virtual_hub
  to   = module.virtual_hubs.azurerm_virtual_hub.virtual_hub
}
