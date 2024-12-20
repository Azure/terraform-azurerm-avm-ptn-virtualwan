locals {
  location            = "australiaeast"
  resource_group_name = "rg-avm-vwan-enabling-bull"
  virtual_hub_name    = "vhub-avm-vwan-enabling-bull-stg"
  address_prefix      = "10.100.0.0/24"
  hub_routing_preference = "ExpressRoute"
  tags = {
    environment = "avm-vwan-staging"
    deployment  = "terraform"
  }
  vwan_name = "vwan-avm-vwan-enabling-bull"
}
data "azurerm_virtual_wan" "vwan" {
  name                = local.vwan_name
  resource_group_name = local.resource_group_name  
}
module "vhub" {
  source                         = "../../modules/virtualhub"

  location               = local.location
  name                   = local.virtual_hub_name
  resource_group_name    = local.resource_group_name
  address_prefix         = local.address_prefix
  hub_routing_preference = local.hub_routing_preference
  tags                   = local.tags
  virtual_wan_id         = data.azurerm_virtual_wan.vwan.id
}
