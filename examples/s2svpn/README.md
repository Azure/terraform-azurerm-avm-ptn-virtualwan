<!-- BEGIN_TF_DOCS -->
# S2s VPN example

This is the S2S VPN example.

```hcl
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
  vpn_gateways_key          = "aue-vhub-vpn-gw"
  vpn_gateways_name         = "vhub-vpn-gw-avm-vwan-${random_pet.vvan_name.id}"
  vpn_site_connections_name = "vhub-vpn-site-conn-avm-vwan-${random_pet.vvan_name.id}"
  vpn_sites_key             = "aue-vhub-vpn-site"
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
    (local.vpn_gateways_key) = {
      name            = local.vpn_gateways_name
      virtual_hub_key = local.virtual_hub_key
    }
  }
  vpn_sites = {
    (local.vpn_sites_key) = {
      name            = local.vpn_sites_name
      virtual_hub_key = local.virtual_hub_key
      links = [{
        name          = "link1"
        provider_name = "Cisco"
        bgp = {
          asn             = azurerm_virtual_network_gateway.gw.bgp_settings[0].asn
          peering_address = azurerm_virtual_network_gateway.gw.bgp_settings[0].peering_addresses[0].default_addresses[0]
        }
        ip_address    = data.azurerm_public_ip.gw_ip.ip_address
        speed_in_mbps = "20"
      }]
    }
  }
  vpn_site_connections = {
    "onprem1" = {
      name                = local.vpn_site_connections_name
      vpn_gateway_key     = local.vpn_gateways_key
      remote_vpn_site_key = local.vpn_sites_key

      vpn_links = [{
        name                                  = "link1"
        bandwidth_mbps                        = 10
        bgp_enabled                           = true
        local_azure_ip_address_enabled        = false
        policy_based_traffic_selector_enabled = false
        ratelimit_enabled                     = false
        route_weight                          = 1
        shared_key                            = nonsensitive(random_password.shared_key.result)
        vpn_site_link_number                  = 0
        vpn_site_key                          = local.vpn_sites_key
      }]
    }
  }
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.7)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.6)

## Resources

The following resources are used by this module:

- [azurerm_local_network_gateway.onpremiseslocalgw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) (resource)
- [azurerm_public_ip.gw_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) (resource)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_subnet.gwsubnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.vm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [azurerm_virtual_network_gateway.gw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) (resource)
- [azurerm_virtual_network_gateway_connection.onpremisesconnection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) (resource)
- [random_password.shared_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [random_pet.vvan_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [azurerm_public_ip.gw_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_s2s_vpn_gw"></a> [s2s\_vpn\_gw](#output\_s2s\_vpn\_gw)

Description: S2S VPN GW

## Modules

The following Modules are called:

### <a name="module_vwan_with_vhub"></a> [vwan\_with\_vhub](#module\_vwan\_with\_vhub)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->