resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

locals {
  location            = "australiaeast"
  resource_group_name = "rg-avm-vwan-${random_pet.vvan_name.id}"
  tags = {
    environment = "avm-vwan-testing"
    deployment  = "terraform"
  }
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
