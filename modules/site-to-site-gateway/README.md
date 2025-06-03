<!-- BEGIN_TF_DOCS -->
# Basic example

This submodule deploys an Azure site-to-site Gateway in the Virtual Hub

```hcl
resource "azurerm_vpn_gateway" "vpn_gateway" {
  for_each = var.vpn_gateways != null ? var.vpn_gateways : {}

  location                              = each.value.location
  name                                  = each.value.name
  resource_group_name                   = each.value.resource_group_name
  virtual_hub_id                        = each.value.virtual_hub_id
  bgp_route_translation_for_nat_enabled = try(each.value.bgp_route_translation_for_nat_enabled, false)
  routing_preference                    = try(each.value.routing_preference, null)
  scale_unit                            = try(each.value.scale_unit, null)
  tags                                  = try(each.value.tags, {})

  dynamic "bgp_settings" {
    for_each = each.value.bgp_settings != null ? [each.value.bgp_settings] : []

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

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_vpn_gateway.vpn_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_vpn_gateways"></a> [vpn\_gateways](#input\_vpn\_gateways)

Description:   Map of objects for S2S VPN Gateways to deploy into the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

  The key is deliberately arbitrary to avoid issues with known after apply values. The value is an object, of which there can be multiple in the map:

  - `name`: Name for the S2S VPN Gateway resource.
  - `virtual_hub_key`: The arbitrary key specified in the map of objects variable called `virtual_hubs` for the object specifying the Virtual Hub you wish to deploy this S2S VPN Gateway into.
  - `tags`: Optional tags to apply to the S2S VPN Gateway resource.
  - `bgp_route_translation_for_nat_enabled`: Optional boolean to enable BGP route translation for NAT.
  - `bgp_settings`: Optional BGP settings object for the S2S VPN Gateway, which includes:
    - `instance_0_bgp_peering_address`: Optional object for the instance 0 BGP peering address, which includes:
      - `custom_ips`: List of custom IPs for the instance 0 BGP peering address.
    - `instance_1_bgp_peering_address`: Optional object for the instance 1 BGP peering address, which includes:
      - `custom_ips`: List of custom IPs for the instance 1 BGP peering address.
    - `peer_weight`: BGP peer weight for the S2S VPN Gateway.
    - `asn`: BGP ASN for the BGP Speaker.
  - `routing_preference`: Optional Azure routing preference lets you to choose how your traffic routes between Azure and the internet. You can choose to route traffic either via the Microsoft network (default value, `Microsoft Network`), or via the ISP network (public internet, set to `Internet`). More context of the configuration can be found in the Microsoft Docs to create a VPN Gateway. Defaults to `Microsoft Network` if not set. Changing this forces a new resource to be created.
  - `scale_unit`: Optional number of scale units for the S2S VPN Gateway. See https://learn.microsoft.com/azure/virtual-wan/gateway-settings#s2s for more information on scale units.

  > Note: There can be multiple objects in this map, one for each S2S VPN Gateway you wish to deploy into the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

Type:

```hcl
map(object({
    name                                  = string
    location                              = string
    resource_group_name                   = string
    virtual_hub_id                        = string
    tags                                  = optional(map(string))
    bgp_route_translation_for_nat_enabled = optional(bool)
    bgp_settings = optional(object({
      instance_0_bgp_peering_address = optional(object({
        custom_ips = list(string)
      }))
      instance_1_bgp_peering_address = optional(object({
        custom_ips = list(string)
      }))
      peer_weight = number
      asn         = number
    }))
    routing_preference = optional(string)
    scale_unit         = optional(number)
  }))
```

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_bgp_settings"></a> [bgp\_settings](#output\_bgp\_settings)

Description: Azure VPN Gateway object

### <a name="output_id"></a> [id](#output\_id)

Description: Azure VPN Gateway ID

### <a name="output_ip_configuration_ids"></a> [ip\_configuration\_ids](#output\_ip\_configuration\_ids)

Description: Azure VPN Gateway BGP Peering Address IP Configuration ID

### <a name="output_resource"></a> [resource](#output\_resource)

Description: Azure VPN Gateway

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Azure VPN Gateway ID

### <a name="output_resource_object"></a> [resource\_object](#output\_resource\_object)

Description: Azure VPN Gateway object

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