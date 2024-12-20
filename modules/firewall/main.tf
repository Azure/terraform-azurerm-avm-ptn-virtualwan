resource "azurerm_firewall" "fw" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id  = var.firewall_policy_id
  tags                = try(var.tags, {})

  virtual_hub {
    virtual_hub_id = var.virtual_hub_id
  }
}