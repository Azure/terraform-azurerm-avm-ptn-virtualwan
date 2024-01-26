resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

locals {
  express_route_gateway_name = "eg-avm-vwan-${random_pet.vvan_name.id}"
  location                   = "australiaeast"
  resource_group_name        = "rg-avm-vwan-${random_pet.vvan_name.id}"
  tags = {
    environment = "avm-vwan-testing"
    deployment  = "terraform"
  }
  virtual_hub_key  = "aue-vhub"
  virtual_hub_name = "vhub-avm-vwan-${random_pet.vvan_name.id}"
  virtual_wan_name = "vwan-avm-vwan-${random_pet.vvan_name.id}"
}

module "vwan_with_vhub" {
  source                         = "../../"
  create_resource_group          = true
  resource_group_name            = local.resource_group_name
  location                       = local.location
  virtual_wan_name               = local.virtual_wan_name
  disable_vpn_encryption         = false
  allow_branch_to_branch_traffic = true
  type                           = "Standard"
  virtual_wan_tags               = local.tags
  virtual_hubs = {
    (local.virtual_hub_key) = {
      name           = local.virtual_hub_name
      location       = local.location
      resource_group = local.resource_group_name
      address_prefix = "10.0.0.0/24"
      tags           = local.tags
    }
  }
  expressroute_gateways = {
    aue-vhub-er-gw = {
      name        = local.express_route_gateway_name
      virtual_hub = local.virtual_hub_key
      scale_units = 1
    }
  }
  er_circuit_connections = {}
}
