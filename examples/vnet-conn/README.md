<!-- BEGIN_TF_DOCS -->
# VNET Conn example

This is the VNET conn example.

```hcl
locals {
  location            = "australiaeast"
  nsg_name            = "avm-vwan-nsg"
  resource_group_name = "tvmVwanRg"
  tags = {
    environment = "avm-vwan-testing"
  }
  vhubs = {
    aue-vhub = {
      name           = "aue_vhub"
      location       = "australiaeast"
      resource_group = "demo-vwan-rsg"
      address_prefix = "192.168.0.0/24"
      tags = {
        "location" = "AUE"
      }
    }
  }
  vnet01 = {
    name          = "avm-vwan-vnet01"
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
      name                      = "aue-vnet-conn"
      virtual_hub_name          = "aue-vhub"
      internet_security_enabled = true
    }
  }
  vwan = {
    name                           = "avm-vwan"
    location                       = local.location
    disable_vpn_encryption         = false
    create_resource_group          = false
    allow_branch_to_branch_traffic = true
    type                           = "Standard"
    tags = {
      environment = "avm-vwan-testing"
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
  name                = local.nsg_name
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

  depends_on = [azurerm_network_security_group.nsg]
}

module "vwan_with_vhub" {
  source                         = "../../"
  create_resource_group          = local.vwan.create_resource_group
  resource_group_name            = azurerm_resource_group.rg.name
  location                       = azurerm_resource_group.rg.location
  virtual_wan_name               = local.vwan.name
  disable_vpn_encryption         = local.vwan.disable_vpn_encryption
  allow_branch_to_branch_traffic = local.vwan.allow_branch_to_branch_traffic
  type                           = local.vwan.type
  virtual_wan_tags               = local.vwan.tags
  virtual_hubs = {
    aue-vhub = local.vhubs.aue-vhub
  }
  virtual_network_connections = {
    aue-vnet = {
      name                      = local.vnet_connections.aue-vnet.name
      virtual_hub_name          = local.vnet_connections.aue-vnet.virtual_hub_name
      remote_virtual_network_id = azurerm_virtual_network.vnet.id
      internet_security_enabled = local.vnet_connections.aue-vnet.internet_security_enabled
    }
  }
  depends_on = [azurerm_resource_group.rg, azurerm_virtual_network.vnet]
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.3)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.7)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.7)

## Resources

The following resources are used by this module:

- [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)

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