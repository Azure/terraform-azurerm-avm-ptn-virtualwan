resource "azurerm_firewall" "fw" {
  for_each = var.firewalls

  location            = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_name].location
  resource_group_name = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_name].resource_group_name
  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.virtual_hub[each.value.virtual_hub_name].id
  }
  name     = each.value.name
  sku_name = each.value.sku_name
  sku_tier = each.value.sku_tier
  tags     = try(each.value.tags, {})
}