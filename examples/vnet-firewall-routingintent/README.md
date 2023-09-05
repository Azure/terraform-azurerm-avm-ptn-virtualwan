# Test secured hub and routing intent in vWAN in Terraform Verified Module for Azure Virtual WAN

This folder contains a Terraform configuration that shows an example of how to test secured hub and routing intent in vWAN in Azure using Terraform.

## Resource deployed

- Virtual WAN:
- Virtual WAN Hub:
  - Virtual WAN Hub.
  - Secured Virtual Hub.
  - Routing intent

## Example

```terraform
module "vwan_with_vhub" {
  source                         = "../../"
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
}

```
