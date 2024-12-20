<!-- BEGIN_TF_DOCS -->
# Basic example

This submodule deploys an Azure ExpressRoute Gateway in the Virtual Hub

```hcl
resource "azurerm_express_route_gateway" "express_route_gateway" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  scale_units         = var.scale_units
  virtual_hub_id      = var.virtual_hub_id
  tags                = try(var.tags, {})
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.7)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.108)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.108)

## Resources

The following resources are used by this module:

- [azurerm_express_route_gateway.express_route_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_gateway) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: Virtual Hub location

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: ExpressRoute Gateway name

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Virtual HUB Resource group name

Type: `string`

### <a name="input_virtual_hub_id"></a> [virtual\_hub\_id](#input\_virtual\_hub\_id)

Description: Virtual Hub ID

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_scale_units"></a> [scale\_units](#input\_scale\_units)

Description: Scale units of the ExpressRoute Gateway

Type: `number`

Default: `2`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Tags of the resource.

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_resource"></a> [resource](#output\_resource)

Description: Azure ExpressRoute Gateway resource name

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Azure ExpressRoute Gateway resource ID

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->