<!-- BEGIN_TF_DOCS -->
# VHUB route table and route table route example

This is the VHUB with route table and routes example.

```hcl
resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

locals {
  location                    = "australiaeast"
  network_security_group_name = "nsg-avm-vwan-${random_pet.vvan_name.id}"
  resource_group_name         = "rg-avm-vwan-${random_pet.vvan_name.id}"
  tags = {
    environment = "avm-vwan-testing"
    deployment  = "terraform"
  }
  virtual_hub_key                 = "aue-vhub"
  virtual_hub_name                = "vhub-avm-vwan-${random_pet.vvan_name.id}"
  virtual_network_connection_name = "vnet-conn-avm-vwan-${random_pet.vvan_name.id}"
  virtual_network_name            = "vnet-avm-vwan-${random_pet.vvan_name.id}"
  virtual_wan_name                = "vwan-avm-vwan-${random_pet.vvan_name.id}"
}

locals {
  vhubs = {
    (local.virtual_hub_key) = {
      name           = local.virtual_hub_name
      location       = local.location
      resource_group = local.resource_group_name
      address_prefix = "192.168.0.0/24"
      tags           = local.tags
    }
  }
  vnet01 = {
    name          = local.virtual_network_name
    address_space = ["10.0.0.0/16"]
    dns_servers   = ["10.0.0.4", "10.0.0.5"]
    subnet1 = {
      name           = "subnet1"
      address_prefix = "10.0.1.0/24"

    }
    subnet2 = {
      name           = "subnet2"
      address_prefix = "10.0.2.0/24"
    }
  }
  vnet_connections = {
    aue-vnet = {
      virtual_network_connection_name = "vnet-conn-avm-vwan-${random_pet.vvan_name.id}"
      name                            = local.virtual_network_connection_name
      virtual_hub_key                 = local.virtual_hub_key
      remote_virtual_network_id       = azurerm_virtual_network.vnet.id
      internet_security_enabled       = true
    }
  }
}

resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = local.resource_group_name
  tags     = local.tags
}

resource "azurerm_network_security_group" "nsg" {
  location            = azurerm_resource_group.rg.location
  name                = local.network_security_group_name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = local.vnet01.address_space
  location            = azurerm_resource_group.rg.location
  name                = local.vnet01.name
  resource_group_name = azurerm_resource_group.rg.name
  dns_servers         = local.vnet01.dns_servers
  tags                = local.tags

  subnet {
    address_prefix = local.vnet01.subnet1.address_prefix
    name           = local.vnet01.subnet1.name
  }
  subnet {
    address_prefix = local.vnet01.subnet2.address_prefix
    name           = local.vnet01.subnet2.name
    security_group = azurerm_network_security_group.nsg.id
  }
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
  virtual_network_connections    = local.vnet_connections
  virtual_hubs                   = local.vhubs

  virtual_hub_route_tables = {
    aue-rt1 = {
      name            = "example-vhubroutetable"
      virtual_hub_key = "aue-vhub"
      labels          = ["label1"]

      routes = {
        aue-r1 = {
          name                = "example-route"
          destinations_type   = "CIDR"
          destinations        = ["10.0.0.0/16"]
          next_hop_type       = "ResourceId"
          vnet_connection_key = "aue-vnet"
        }
      }
    }

  }
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

- [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [random_pet.vvan_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

No optional inputs.

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_vwan_with_vhub"></a> [vwan\_with\_vhub](#module\_vwan\_with\_vhub)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->