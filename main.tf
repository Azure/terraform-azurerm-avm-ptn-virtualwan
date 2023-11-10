# Create rgs as defined by var.virtual_wan
resource "azurerm_resource_group" "rg" {
  for_each = var.resource_group_name != null ? toset([var.resource_group_name]) : toset([])

  location = var.location
  name     = var.resource_group_name
  tags     = try(merge(var.resource_group_tags, var.tags), {})
}

resource "azurerm_virtual_wan" "virtual_wan" {
  name                              = var.virtual_wan_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  disable_vpn_encryption            = var.disable_vpn_encryption
  allow_branch_to_branch_traffic    = try(var.allow_branch_to_branch_traffic, true)
  office365_local_breakout_category = try(var.office365_local_breakout_category, "None")
  type                              = var.type
  tags                              = merge(var.tags, var.virtual_wan_tags)
}

resource "azurerm_virtual_hub" "virtual_hub" {
  for_each = local.virtual_hub != null && length(local.virtual_hub) > 0 ? local.virtual_hub : {}

  name                = each.value.name
  location            = each.value.location
  resource_group_name = var.resource_group_name
  virtual_wan_id      = azurerm_virtual_wan.virtual_wan.id
  address_prefix      = each.value.address_prefix
  tags                = try(each.value.tags, {})
}