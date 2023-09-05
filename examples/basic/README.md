# Test vWAN (No gateways or hubs) in Terraform Verified Module for Azure Virtual WAN

This folder contains a Terraform configuration that shows an example of how to test vWAN in Azure using Terraform.

## Resource deployed

- Virtual WAN:
- Virtual WAN Hub:
  - Virtual WAN Hub.

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
}

```
