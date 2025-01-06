
resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

locals {
  address_prefix         = "10.100.0.0/24"
  hub_routing_preference = "ExpressRoute"
  location               = "australiaeast"
  resource_group_name    = "rg-avm-vwan-${random_pet.vvan_name.id}"
  tags = {
    environment = "avm-vwan-testing"
    deployment  = "terraform"
  }
  virtual_hub_name = "vwan-avm-vwan-${random_pet.vvan_name.id}-vhub-02"
  virtual_wan_name = "vwan-avm-vwan-${random_pet.vvan_name.id}"
}

module "vwan_with_vhub" {
  source                         = "../../"
  resource_group_name            = local.resource_group_name
  create_resource_group          = true
  location                       = local.location
  virtual_wan_name               = local.virtual_wan_name
  allow_branch_to_branch_traffic = true
  type                           = "Standard"
  virtual_wan_tags               = local.tags
}

data "azurerm_virtual_wan" "vwan" {
  name                = local.virtual_wan_name
  resource_group_name = local.resource_group_name

  depends_on = [module.vwan_with_vhub]
}


module "vhub" {
  source = "../../modules/virtualhub"

  location               = local.location
  name                   = local.virtual_hub_name
  resource_group_name    = local.resource_group_name
  address_prefix         = local.address_prefix
  hub_routing_preference = local.hub_routing_preference
  tags                   = local.tags
  virtual_wan_id         = data.azurerm_virtual_wan.vwan.id
  depends_on             = [data.azurerm_virtual_wan.vwan]
}
