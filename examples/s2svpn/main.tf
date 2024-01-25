resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

resource "random_password" "shared_key" {
  length           = 12
  override_special = "!#$%&*()-_=+[]{}<>:?"
  special          = true
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
  vpn_gateways = {
    "aue-vhub-vpn-gw" = {
      name        = random_pet.vvan_name.id
      virtual_hub = random_pet.vvan_name.id
    }
  }
  vpn_sites = {
    "aue-vhub-vpn-site" = {
      name             = random_pet.vvan_name.id
      virtual_hub_name = random_pet.vvan_name.id
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
      name                 = random_pet.vvan_name.id
      vpn_gateway_name     = random_pet.vvan_name.id
      remote_vpn_site_name = random_pet.vvan_name.id

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