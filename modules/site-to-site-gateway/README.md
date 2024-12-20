<!-- BEGIN_TF_DOCS -->
# Basic example

This submodule deploys an Azure site-to-site Gateway in the Virtual Hub

```hcl
resource "azurerm_vpn_gateway" "vpn_gateway" {
  location                              = var.location
  name                                  = var.name
  resource_group_name                   = var.resource_group_name
  virtual_hub_id                        = var.virtual_hub_id
  bgp_route_translation_for_nat_enabled = try(var.bgp_route_translation_for_nat_enabled, false)
  routing_preference                    = try(var.routing_preference, null)
  scale_unit                            = try(var.scale_unit, null)
  tags                                  = try(var.tags, {})

  dynamic "bgp_settings" {
    for_each = var.bgp_settings != null ? [var.bgp_settings] : []

    content {
      asn         = bgp_settings.value.asn
      peer_weight = bgp_settings.value.peer_weight

      dynamic "instance_0_bgp_peering_address" {
        for_each = bgp_settings.value.instance_0_bgp_peering_address != null ? [bgp_settings.value.instance_0_bgp_peering_address] : []

        content {
          custom_ips = try(instance_0_bgp_peering_address.value.custom_ips, null)
        }
      }
      dynamic "instance_1_bgp_peering_address" {
        for_each = bgp_settings.value.instance_1_bgp_peering_address != null ? [bgp_settings.value.instance_1_bgp_peering_address] : []

        content {
          custom_ips = try(instance_1_bgp_peering_address.value.custom_ips, null)
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

- [azurerm_vpn_gateway.vpn_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_bgp_route_translation_for_nat_enabled"></a> [bgp\_route\_translation\_for\_nat\_enabled](#input\_bgp\_route\_translation\_for\_nat\_enabled)

Description: BGP route translation for NAT enabled

Type: `bool`

### <a name="input_bgp_settings"></a> [bgp\_settings](#input\_bgp\_settings)

Description: BGP settings of the VPN Gateway

Type:

```hcl
object({
    asn = number
    instance_0_bgp_peering_address = optional(object({
      custom_ips = optional(list(string))
    }))
    instance_1_bgp_peering_address = optional(object({
      custom_ips = optional(list(string))
    }))
    peer_weight = number
  })
```

### <a name="input_location"></a> [location](#input\_location)

Description: Location of the VPN Gateway

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: Name of the VPN Gateway

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Resource Group name of the VPN Gateway

Type: `string`

### <a name="input_routing_preference"></a> [routing\_preference](#input\_routing\_preference)

Description: Routing preference of the VPN Gateway

Type: `string`

### <a name="input_scale_unit"></a> [scale\_unit](#input\_scale\_unit)

Description: Scale unit of the VPN Gateway

Type: `number`

### <a name="input_virtual_hub_id"></a> [virtual\_hub\_id](#input\_virtual\_hub\_id)

Description: Virtual Hub ID of the VPN Gateway

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (optional) Tags of the VPN Gateway

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_bgp_settings"></a> [bgp\_settings](#output\_bgp\_settings)

Description: Azure VPN Gateway object

### <a name="output_id"></a> [id](#output\_id)

Description: Azure VPN Gateway ID

### <a name="output_resource"></a> [resource](#output\_resource)

Description: Azure VPN Gateway

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Azure VPN Gateway ID

### <a name="output_vpn_gateway_id"></a> [vpn\_gateway\_id](#output\_vpn\_gateway\_id)

Description: Azure VPN Gateway resource ID

### <a name="output_vpn_gateway_name"></a> [vpn\_gateway\_name](#output\_vpn\_gateway\_name)

Description: Azure VPN Gateway resource name

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->