resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

resource "random_password" "shared_key" {
  length           = 12
  override_special = "!#$%&*()-_=+[]{}<>:?"
  special          = true
}

locals {
  location            = "australiaeast"
  resource_group_name = "rg-avm-vwan-${random_pet.vvan_name.id}"
  tags = {
    environment = "avm-vwan-testing"
    deployment  = "terraform"
  }
  virtual_hub_key           = "aue-vhub"
  virtual_hub_name          = "vhub-avm-vwan-${random_pet.vvan_name.id}"
  virtual_wan_name          = "vwan-avm-vwan-${random_pet.vvan_name.id}"
  vpn_gateways_name         = "vhub-vpn-gw-avm-vwan-${random_pet.vvan_name.id}"
  vpn_site_connections_name = "vhub-vpn-site-conn-avm-vwan-${random_pet.vvan_name.id}"
  vpn_sites_name            = "vhub-vpn-site-avm-vwan-${random_pet.vvan_name.id}"
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
  vpn_gateways = {
    "aue-vhub-vpn-gw" = {
      name        = local.vpn_gateways_name
      virtual_hub = local.virtual_hub_key
    }
  }
  vpn_sites = {
    "aue-vhub-vpn-site" = {
      name             = local.vpn_sites_name
      virtual_hub_name = local.virtual_hub_key
      links = [{
        name          = "link1"
        provider_name = "Cisco"
        bgp = {
          asn             = azurerm_virtual_network_gateway.gw.bgp_settings[0].asn
          peering_address = azurerm_virtual_network_gateway.gw.bgp_settings[0].peering_addresses[0].default_addresses[0]
        }
        ip_address    = azurerm_public_ip.gw_ip.ip_address
        speed_in_mbps = "20"
      }]
    }
  }
  vpn_site_connections = {
    "onprem1" = {
      name                 = local.vpn_site_connections_name
      vpn_gateway_name     = local.vpn_gateways_name
      remote_vpn_site_name = local.vpn_sites_name

      vpn_links = [{
        name                                  = "link1"
        bandwidth_mbps                        = 10
        bgp_enabled                           = true
        local_azure_ip_address_enabled        = false
        policy_based_traffic_selector_enabled = false
        ratelimit_enabled                     = false
        route_weight                          = 1
        shared_key                            = random_password.shared_key.result
        vpn_site_link_number                  = 0
      }]
    }
  }
}

output "s2s_vpn_gw" {
  value       = [for gw in module.vwan_with_vhub.s2s_vpn_gw : gw]
  description = "S2S VPN GW"
}