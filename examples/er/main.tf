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
  source = "../../"

  location                       = local.location
  resource_group_name            = local.resource_group_name
  virtual_wan_name               = local.virtual_wan_name
  allow_branch_to_branch_traffic = true
  create_resource_group          = true
  disable_vpn_encryption         = false
  er_circuit_connections         = {}
  expressroute_gateways = {
    aue-vhub-er-gw = {
      name            = local.express_route_gateway_name
      virtual_hub_key = local.virtual_hub_key
      scale_units     = 1
    }
  }
  type = "Standard"
  virtual_hubs = {
    (local.virtual_hub_key) = {
      name           = local.virtual_hub_name
      location       = local.location
      resource_group = local.resource_group_name
      address_prefix = "10.0.0.0/24"
      tags           = local.tags
    }
  }
  virtual_wan_tags = local.tags
}
