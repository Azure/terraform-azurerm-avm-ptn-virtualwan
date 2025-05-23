<!-- BEGIN_TF_DOCS -->
# VHUB example

This is the VHUB using submodule example.

```hcl

resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

locals {
  address_prefix      = "10.100.0.0/24"
  location            = "australiaeast"
  resource_group_name = "rg-avm-vwan-${random_pet.vvan_name.id}"
  tags = {
    environment = "avm-vwan-testing"
    deployment  = "terraform"
  }
  virtual_hub_key  = "aue-vhub-02"
  virtual_hub_name = "vwan-avm-vwan-${random_pet.vvan_name.id}-vhub-02"
  virtual_wan_name = "vwan-avm-vwan-${random_pet.vvan_name.id}"
}

module "vwan_with_vhub" {
  source = "../../"

  location                       = local.location
  resource_group_name            = local.resource_group_name
  virtual_wan_name               = local.virtual_wan_name
  allow_branch_to_branch_traffic = true
  create_resource_group          = true
  type                           = "Standard"
  virtual_wan_tags               = local.tags
}

data "azurerm_virtual_wan" "vwan" {
  name                = local.virtual_wan_name
  resource_group_name = local.resource_group_name

  depends_on = [module.vwan_with_vhub]
}


module "vhub" {
  source = "../../modules/virtualhub"

  virtual_hubs = {
    (local.virtual_hub_key) = {
      name           = local.virtual_hub_name
      location       = local.location
      resource_group = local.resource_group_name
      address_prefix = local.address_prefix
      tags           = local.tags
      virtual_wan_id = data.azurerm_virtual_wan.vwan.id
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

- [random_pet.vvan_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
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

### <a name="module_vwan_with_vhub"></a> [vwan\_with\_vhub](#module\_vwan\_with\_vhub)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->