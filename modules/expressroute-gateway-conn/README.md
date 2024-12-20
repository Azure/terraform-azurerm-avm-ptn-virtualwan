<!-- BEGIN_TF_DOCS -->
# Basic example

This submodule deploys an Azure ExpressRoute Connection between ExpressRoute Gateway and ExpressRoute Circuit in the Virtual Hub

```hcl
# Create the Express Route Connection
resource "azurerm_express_route_connection" "er_connection" {
  express_route_circuit_peering_id = var.express_route_circuit_peering_id
  express_route_gateway_id         = var.express_route_gateway_id
  name                             = var.name
  authorization_key                = try(var.authorization_key, null)
  enable_internet_security         = try(var.enable_internet_security, null)
  routing_weight                   = try(var.routing_weight, null)

  dynamic "routing" {
    for_each = var.routing != null && length(var.routing) > 0 ? [var.routing] : []

    content {
      associated_route_table_id = routing.value.associated_route_table_id
      inbound_route_map_id      = try(routing.value.inbound_route_map_id, null)
      outbound_route_map_id     = try(routing.value.outbound_route_map_id, null)

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table != null ? [routing.value.propagated_route_table] : []

        content {
          labels          = try(propagated_route_tables.value.labels, [])
          route_table_ids = try(propagated_route_tables.value.route_table_ids, [])
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

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.108)

## Resources

The following resources are used by this module:

- [azurerm_express_route_connection.er_connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_connection) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_express_route_circuit_peering_id"></a> [express\_route\_circuit\_peering\_id](#input\_express\_route\_circuit\_peering\_id)

Description: Express Route Circuit Peering ID

Type: `string`

### <a name="input_express_route_gateway_id"></a> [express\_route\_gateway\_id](#input\_express\_route\_gateway\_id)

Description: Express Route Gateway ID

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: ExpressRoute Gateway Connection name

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_authorization_key"></a> [authorization\_key](#input\_authorization\_key)

Description: Authorization key for the Express Route Connection

Type: `string`

Default: `null`

### <a name="input_enable_internet_security"></a> [enable\_internet\_security](#input\_enable\_internet\_security)

Description: Enable internet security for the Express Route Connection

Type: `bool`

Default: `false`

### <a name="input_routing"></a> [routing](#input\_routing)

Description: Routing configuration for the Express Route Connection

Type:

```hcl
map(object({
    associated_route_table_id = string
    inbound_route_map_id      = string
    outbound_route_map_id     = string
    propagated_route_table = map(object({
      labels          = list(string)
      route_table_ids = list(string)
    }))
  }))
```

Default: `null`

### <a name="input_routing_weight"></a> [routing\_weight](#input\_routing\_weight)

Description: Routing weight for the Express Route Connection

Type: `number`

Default: `0`

## Outputs

The following outputs are exported:

### <a name="output_resource"></a> [resource](#output\_resource)

Description: Azure ExpressRoute Connection resource

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Azure ExpressRoute Connection resource ID

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->