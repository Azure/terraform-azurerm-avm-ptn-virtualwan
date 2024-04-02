resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

locals {
  firewall_key        = "aue-vhub-fw"
  firewall_name       = "fw-avm-vwan-${random_pet.vvan_name.id}"
  location            = "australiaeast"
  resource_group_name = "rg-avm-vwan-${random_pet.vvan_name.id}"
  tags = {
    environment = "avm-vwan-testing"
    deployment  = "terraform"
  }
  virtual_hub_key  = "aue-vhub"
  virtual_hub_name = "vhub-avm-vwan-${random_pet.vvan_name.id}"
  virtual_wan_name = "vwan-avm-vwan-${random_pet.vvan_name.id}"
}

module "firewall_policy" {
  source             = "Azure/avm-res-network-firewallpolicy/azurerm"
  name                = module.naming.firewall_policy.name_unique
  location            = local.location
  resource_group_name = local.resource_group_name
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
  firewalls = {
    (local.firewall_key) = {
      sku_name        = "AZFW_Hub"
      sku_tier        = "Standard"
      name            = local.firewall_name
      virtual_hub_key = local.virtual_hub_key
      firewall_policy_id = module.firewall_policy.id
    }
  }
  routing_intents = {
    "aue-vhub-routing-intent" = {
      name            = "private-routing-intent"
      virtual_hub_key = local.virtual_hub_key
      routing_policies = [{
        name                  = "aue-vhub-routing-policy-private"
        destinations          = ["PrivateTraffic"]
        next_hop_firewall_key = local.firewall_key
      }]
    }
  }
}
