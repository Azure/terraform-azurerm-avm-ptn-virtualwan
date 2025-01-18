<!-- BEGIN_TF_DOCS -->
# Basic example

This submodule deploys an Azure ExpressRoute Gateway in the Virtual Hub

```hcl
resource "azurerm_express_route_gateway" "express_route_gateway" {
  for_each = var.expressroute_gateways != null && length(var.expressroute_gateways) > 0 ? var.expressroute_gateways : {}

  location                      = each.value.location
  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  scale_units                   = each.value.scale_units
  virtual_hub_id                = each.value.virtual_hub_id
  allow_non_virtual_wan_traffic = each.value.allow_non_virtual_wan_traffic
  tags                          = try(each.value.tags, {})
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

- [azurerm_express_route_gateway.express_route_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_gateway) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_expressroute_gateways"></a> [expressroute\_gateways](#input\_expressroute\_gateways)

Description:   
Map of objects for Express Route Gateways to deploy into the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

The key is deliberately arbitrary to avoid issues with known after apply values. The value is an object, of which there can be multiple in the map:

- `name`: Name for the ExpressRoute Gateway to deploy in the Virtual WAN Virtual Hub.
- `virtual_hub_id`: The object ID of the virtual hub.
- `tags`: Optional tags to apply to the ExpressRoute Gateway resource.
- `allow_non_virtual_wan_traffic`: Optional boolean to configures this gateway to accept traffic from non Virtual WAN networks. Defaults to `false`.
- `scale_units`: Optional number of scale units for the ExpressRoute Gateway. Defaults to `1`. See: https://learn.microsoft.com/azure/virtual-wan/virtual-wan-expressroute-about#expressroute-gateway-performance for more information on scale units.

> Note: There can be multiple objects in this map, one for each ExpressRoute Gateway you wish to deploy into the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

Type:

```hcl
map(object({
    name                          = string
    virtual_hub_id                = string
    location                      = string
    resource_group_name           = string
    tags                          = optional(map(string))
    allow_non_virtual_wan_traffic = optional(bool, false)
    scale_units                   = optional(number, 1)
  }))
```

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_resource"></a> [resource](#output\_resource)

Description: Azure ExpressRoute Gateway resource name

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Azure ExpressRoute Gateway resource ID

### <a name="output_resource_object"></a> [resource\_object](#output\_resource\_object)

Description: Azure ExpressRoute Gateway resource object

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->