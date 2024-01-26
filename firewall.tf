resource "azurerm_firewall" "fw" {
  for_each = var.firewalls

  location            = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_key].location
  name                = each.value.name
  resource_group_name = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_key].resource_group_name
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier
  tags                = try(each.value.tags, {})

  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_key].id
  }
}