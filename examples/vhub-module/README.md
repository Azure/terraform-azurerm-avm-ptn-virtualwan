<!-- BEGIN_TF_DOCS -->
# VHUB example

This is the VHUB using submodule example.

```hcl
locals {
  address_prefix         = "10.100.0.0/24"
  hub_routing_preference = "ExpressRoute"
  location               = "australiaeast"
  resource_group_name    = "rg-avm-vwan-enabling-bull"
  tags = {
    environment = "avm-vwan-staging"
    deployment  = "terraform"
  }
  virtual_hub_name = "vhub-avm-vwan-enabling-bull-stg"
  vwan_name        = "vwan-avm-vwan-enabling-bull"
}
data "azurerm_virtual_wan" "vwan" {
  name                = local.vwan_name
  resource_group_name = local.resource_group_name
}
module "vhub" {
  source = "../../modules/virtualhub"

  location               = local.location
  name                   = local.virtual_hub_name
  resource_group_name    = local.resource_group_name
  address_prefix         = local.address_prefix
  hub_routing_preference = local.hub_routing_preference
  tags                   = local.tags
  virtual_wan_id         = data.azurerm_virtual_wan.vwan.id
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.7)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.108)

## Resources

The following resources are used by this module:

- [azurerm_virtual_wan.vwan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_wan) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

No optional inputs.

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_vhub"></a> [vhub](#module\_vhub)

Source: ../../modules/virtualhub

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->