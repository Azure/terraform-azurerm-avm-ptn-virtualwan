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

resource "azurerm_virtual_hub_route_table" "virtual_hub_route_table" {
  for_each = var.virtual_hub_route_tables

  name           = each.value.name
  virtual_hub_id = module.virtual_hubs.resource_id[each.value.virtual_hub_key]
  labels         = each.value.labels

  dynamic "route" {
    for_each = each.value.routes

    content {
      destinations      = route.value.destinations
      destinations_type = route.value.destinations_type
      name              = route.value.name
      next_hop          = try(module.virtual_network_connections.resource_object[route.value.vnet_connection_key].id, route.value.next_hop)
      next_hop_type     = route.value.next_hop_type
    }
  }
}
