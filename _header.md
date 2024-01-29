# Terraform Verified Module for Azure Virtual WAN Hub Networking

[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/Azure/terraform-azurerm-vwan.svg)](http://isitmaintained.com/project/Azure/terraform-azurerm-vwan "Average time to resolve an issue")
[![Percentage of issues still open](http://isitmaintained.com/badge/open/Azure/terraform-azurerm-vwan.svg)](http://isitmaintained.com/project/Azure/terraform-azurerm-vwan "Percentage of issues still open")

This module is designed to simplify the creation of virtual wan based networks in Azure.

## Features

- Virtual WAN:
- Virtual WAN Hub:
  - Virtual WAN Hub.
  - Secured Virtual Hub.
  - Routing intent
- Azure Firewall
  - Secured Virtual Hub
  - AzureFirewallSubnet.
- Site-to-Site Virtual Network Gateway:
  - S2S VPN Gateway.
  - Active-Active or Single.
  - VPN Site
  - VPN Site Connection
  - Deployment of `GatewaySubnet`.
- Point-to-Site Virtual Network Gateway:
  - P2S VPN Gateway.
  - P2S server configuration.
  - Active-Active or Single.
  - Deployment of `GatewaySubnet`.
- ER Gateway:
  - ER Gateway.
  - ER Gateway Connection.
  - Active-Active or Single.
  - Deployment of `GatewaySubnet`.

## Example

```terraform
module "vwan_with_vhub" {
  source                         = "../../"
  resource_group_name            = "tvmVwanRg"
  location                       = "australiaeast"
  virtual_wan_name               = "tvmVwan"
  disable_vpn_encryption         = false
  allow_branch_to_branch_traffic = true
  bgp_community                  = "12076:51010"
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
  vpn_gateways = {
    "aue-vhub-vpn-gw" = {
      name            = "aue-vhub-vpn-gw"
      virtual_hub_key = "aue-vhub"
    }
  }
  vpn_sites = {
    "aue-vhub-vpn-site" = {
      name            = "aue-vhub-vpn-site"
      virtual_hub_key = "aue-vhub"
      links = [{
        name          = "link1"
        provider_name = "Cisco"
        bgp = {
          asn             = 65001
          peering_address = "172.16.1.254"
        }
        ip_address    = "20.28.182.157"
        speed_in_mbps = "20"
      }]
    }
  }
  vpn_site_connections = {
    "onprem1" = {
      name                = "aue-vhub-vpn-conn01"
      vpn_gateway_key     = "aue-vhub-vpn-gw"
      remote_vpn_site_key = "aue-vhub-vpn-site"

      vpn_links = [{
        name                                  = "link1"
        bandwidth_mbps                        = 10
        bgp_enabled                           = true
        local_azure_ip_address_enabled        = false
        policy_based_traffic_selector_enabled = false
        ratelimit_enabled                     = false
        route_weight                          = 1
        shared_key                            = "AzureA1b2C3"
        vpn_site_link_number                  = 0
      }]
    }
  }
}

```
