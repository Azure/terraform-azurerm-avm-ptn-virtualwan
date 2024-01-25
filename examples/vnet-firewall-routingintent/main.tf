module "vwan_with_vhub" {
  source                         = "../../"
  create_resource_group          = true
  resource_group_name            = "tvmVwanRg"
  location                       = "australiaeast"
  virtual_wan_name               = "tvmVwan"
  disable_vpn_encryption         = false
  allow_branch_to_branch_traffic = true
  type                           = "Standard"
  virtual_wan_tags = {
    environment = "dev"
    deployment  = "terraform"
  }
  virtual_hubs = {
    aue-vhub = {
      name           = "aue_vhub"
      location       = "australiaeast"
      resource_group = "demo-vwan-rsg"
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
      name             = "aue-hub-fw"
      virtual_hub_name = "aue-vhub"
    }
  }
  routing_intents = {
    "aue-vhub-routing-intent" = {
      name             = "private-routing-intent"
      virtual_hub_name = "aue-vhub"
      routing_policies = [{
        name         = "aue-vhub-routing-policy-private"
        destinations = ["PrivateTraffic"]
        next_hop     = "aue-vhub-fw"
      }]
    }
  }
}
