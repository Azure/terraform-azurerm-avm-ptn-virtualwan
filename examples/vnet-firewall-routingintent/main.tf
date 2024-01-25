resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

module "vwan_with_vhub" {
  source                         = "../../"
  create_resource_group          = true
  resource_group_name            = random_pet.vvan_name.id
  location                       = "australiaeast"
  virtual_wan_name               = random_pet.vvan_name.id
  disable_vpn_encryption         = false
  allow_branch_to_branch_traffic = true
  type                           = "Standard"
  virtual_wan_tags = {
    environment = "dev"
    deployment  = "terraform"
  }
  virtual_hubs = {
    (random_pet.vvan_name.id) = {
      name           = random_pet.vvan_name.id
      location       = "australiaeast"
      resource_group = random_pet.vvan_name.id
      address_prefix = "10.0.0.0/24"
      tags = {
        "location" = "AUE"
      }
    }
  }
  firewalls = {
    "aue-vhub-fw" = {
      sku_name         = "AZFW_Hub"
      sku_tier         = "Standard"
      name             = random_pet.vvan_name.id
      virtual_hub_name = random_pet.vvan_name.id
    }
  }
  routing_intents = {
    "aue-vhub-routing-intent" = {
      name             = "private-routing-intent"
      virtual_hub_name = random_pet.vvan_name.id
      routing_policies = [{
        name         = "aue-vhub-routing-policy-private"
        destinations = ["PrivateTraffic"]
        next_hop     = random_pet.vvan_name.id
      }]
    }
  }
}
