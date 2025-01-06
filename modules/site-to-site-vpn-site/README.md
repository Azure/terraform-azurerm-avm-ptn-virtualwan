<!-- BEGIN_TF_DOCS -->
# Basic example

This submodule deploys an Azure site-to-site Gateway site in the Virtual Hub

```hcl
# Create a vpn site. Sites represent the Physical locations (On-Premises) you wish to connect.
resource "azurerm_vpn_site" "vpn_site" {
  location            = var.vpn_sites.location
  name                = var.vpn_sites.name
  resource_group_name = var.vpn_sites.resource_group_name
  virtual_wan_id      = var.vpn_sites.virtual_wan_id
  address_cidrs       = try(var.vpn_sites.address_cidrs, null)
  device_model        = try(var.vpn_sites.device_model, null)
  device_vendor       = try(var.vpn_sites.device_vendor, null)
  tags                = try(var.vpn_sites.tags, {})

  dynamic "link" {
    for_each = var.vpn_sites.links != null && length(var.vpn_sites.links) > 0 ? var.vpn_sites.links : []

    content {
      name          = link.value.name
      fqdn          = try(link.value.fqdn, null)
      ip_address    = try(link.value.ip_address, null)
      provider_name = try(link.value.provider_name, null)
      speed_in_mbps = link.value.speed_in_mbps

      dynamic "bgp" {
        for_each = link.value.bgp != null ? [link.value.bgp] : []

        content {
          asn             = bgp.value.asn
          peering_address = bgp.value.peering_address
        }
      }
    }
  }
  dynamic "o365_policy" {
    for_each = var.vpn_sites.o365_policy != null ? [var.vpn_sites.o365_policy] : []

    content {
      traffic_category {
        allow_endpoint_enabled    = try(o365_policy.value.traffic_category.allow_endpoint_enabled, null)
        default_endpoint_enabled  = try(o365_policy.value.traffic_category.default_endpoint_enabled, null)
        optimize_endpoint_enabled = try(o365_policy.value.traffic_category.optimize_endpoint_enabled, null)
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

- [azurerm_vpn_site.vpn_site](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_site) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_vpn_sites"></a> [vpn\_sites](#input\_vpn\_sites)

Description: Azure Virtual WAN vpn sites

Type:

```hcl
object({
    location            = string
    name                = string
    resource_group_name = string
    virtual_wan_id      = string
    address_cidrs       = optional(list(string))
    device_model        = optional(string)
    device_vendor       = optional(string)
    tags                = optional(map(string))
    links = list(object({
      name = string
      bgp = optional(object({
        asn             = number
        peering_address = string
      }))
      fqdn          = optional(string)
      ip_address    = optional(string)
      provider_name = optional(string)
      speed_in_mbps = optional(number)
    }))
    o365_policy = optional(object({
      traffic_category = object({
        allow_endpoint_enabled    = optional(bool)
        default_endpoint_enabled  = optional(bool)
        optimize_endpoint_enabled = optional(bool)
      })
    }))
  })
```

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_links"></a> [links](#output\_links)

Description: Azure VPN Site links

### <a name="output_resource"></a> [resource](#output\_resource)

Description: Azure VPN Site resource

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Azure VPN Site ID

### <a name="output_vpn_site_name"></a> [vpn\_site\_name](#output\_vpn\_site\_name)

Description: Azure VPN Site names

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->