module "firewalls" {
  source = "./modules/firewall"

  for_each = var.firewalls

  location            = module.virtual_hubs[each.value.virtual_hub_key].location
  name                = each.value.name
  resource_group_name = module.virtual_hubs[each.value.virtual_hub_key].resource_group_name
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier
  firewall_policy_id  = each.value.firewall_policy_id
  tags                = try(each.value.tags, {})
  virtual_hub_id      = module.virtual_hubs[each.value.virtual_hub_key].resource_id
}

