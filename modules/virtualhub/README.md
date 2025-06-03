<!-- BEGIN_TF_DOCS -->
# Basic example

This submodule deploys an Azure virtual wan virtual hub

```hcl

resource "azurerm_virtual_hub" "virtual_hub" {
  for_each = var.virtual_hubs != null ? var.virtual_hubs : {}

  location                               = each.value.location
  name                                   = each.value.name
  resource_group_name                    = each.value.resource_group
  address_prefix                         = each.value.address_prefix
  hub_routing_preference                 = each.value.hub_routing_preference
  sku                                    = each.value.sku
  tags                                   = each.value.tags
  virtual_router_auto_scale_min_capacity = each.value.virtual_router_auto_scale_min_capacity
  virtual_wan_id                         = each.value.virtual_wan_id
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.7)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_virtual_hub.virtual_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_virtual_hubs"></a> [virtual\_hubs](#input\_virtual\_hubs)

Description:   Map of objects for Virtual Hubs to deploy into the Virtual WAN.

  The key is deliberately arbitrary to avoid issues with known after apply values. The value is an object, of which there can be multiple in the map:

  - `name`: Name for the Virtual Hub resource.
  - `location`: Location for the Virtual Hub resource.
  - `resource_group`: Optional resource group name to deploy the Virtual Hub into. If not specified, the Virtual Hub will be deployed into the resource group specified in the variable `resource_group_name`, e.g. the same as the Virtual WAN itself.
  - `address_prefix`: Address prefix for the Virtual Hub. Recommend using a `/23` CIDR block.
  - `tags`: Optional tags to apply to the Virtual Hub resource.
  - `hub_routing_preference`: Optional hub routing preference for the Virtual Hub. Possible values are: `ExpressRoute`, `ASPath`, `VpnGateway`. Defaults to `ExpressRoute`. See https://learn.microsoft.com/azure/virtual-wan/hub-settings#routing-preference for more information.
  - `virtual_router_auto_scale_min_capacity`: Optional minimum capacity for the Virtual Router auto scale. Defaults to `2`. See https://learn.microsoft.com/azure/virtual-wan/hub-settings#capacity for more information.

  > Note: There can be multiple objects in this map, one for each Virtual Hub you wish to deploy into the Virtual WAN. Multiple Virtual Hubs in the same region/location can be deployed into the same Virtual WAN also.

Type:

```hcl
map(object({
    name                                   = string
    location                               = string
    resource_group                         = optional(string, null)
    address_prefix                         = string
    tags                                   = optional(map(string))
    virtual_wan_id                         = string
    hub_routing_preference                 = optional(string, "ExpressRoute")
    virtual_router_auto_scale_min_capacity = optional(number, 2)
    sku                                    = optional(string, "Standard")
  }))
```

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_location"></a> [location](#output\_location)

Description: Virtual Hub Location

### <a name="output_resource"></a> [resource](#output\_resource)

Description: Virtual Hub

### <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name)

Description: Resource Group Name

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Virtual Hub ID

### <a name="output_resource_ids"></a> [resource\_ids](#output\_resource\_ids)

Description: Virtual Hub IDs

### <a name="output_resource_names"></a> [resource\_names](#output\_resource\_names)

Description: Virtual Hub Names

### <a name="output_resource_object"></a> [resource\_object](#output\_resource\_object)

Description: Virtual Hub Object

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->