<!-- BEGIN_TF_DOCS -->
# VNET Firewall Routing Intent example

This is the frewall linked to a firewall policy example

```hcl
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


resource "azurerm_firewall_policy" "this" {
  location            = local.location
  name                = "vhub-avm-vwan-${random_pet.vvan_name.id}-fw-policy"
  resource_group_name = module.vwan_with_vhub.resource_group_name
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
      sku_name           = "AZFW_Hub"
      sku_tier           = "Standard"
      name               = local.firewall_name
      virtual_hub_key    = local.virtual_hub_key
      firewall_policy_id = azurerm_firewall_policy.this.id
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

output "firewall_private_ip_address_by_hub" {
  description = "Private IP Address of the Azure Firewall by Hub"
  value       = module.vwan_with_vhub.firewall_ip_addresses_by_hub_key[local.virtual_hub_key].private_ip_address
}

output "firewall_private_ip_address_by_firewall" {
  description = "Private IP Address of the Azure Firewall by Firewall"
  value       = module.vwan_with_vhub.firewall_ip_addresses_by_firewall_key[local.firewall_key].private_ip_address
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.7)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.108)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.6)

## Resources

The following resources are used by this module:

- [azurerm_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy) (resource)
- [random_pet.vvan_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_firewall_private_ip_address_by_firewall"></a> [firewall\_private\_ip\_address\_by\_firewall](#output\_firewall\_private\_ip\_address\_by\_firewall)

Description: Private IP Address of the Azure Firewall by Firewall

### <a name="output_firewall_private_ip_address_by_hub"></a> [firewall\_private\_ip\_address\_by\_hub](#output\_firewall\_private\_ip\_address\_by\_hub)

Description: Private IP Address of the Azure Firewall by Hub

## Modules

The following Modules are called:

### <a name="module_vwan_with_vhub"></a> [vwan\_with\_vhub](#module\_vwan\_with\_vhub)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->