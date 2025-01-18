<!-- BEGIN_TF_DOCS -->
# Basic example

This submodule deploys an Azure site-to-site Gateway site in the Virtual Hub

```hcl
# Create a vpn site. Sites represent the Physical locations (On-Premises) you wish to connect.
resource "azurerm_vpn_site" "vpn_site" {
  for_each = var.vpn_sites != null ? var.vpn_sites : {}

  location            = each.value.location
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  virtual_wan_id      = each.value.virtual_wan_id
  address_cidrs       = try(each.value.address_cidrs, null)
  device_model        = try(each.value.device_model, null)
  device_vendor       = try(each.value.device_vendor, null)
  tags                = try(each.value.tags, {})

  dynamic "link" {
    for_each = each.value.links != null && length(each.value.links) > 0 ? each.value.links : []

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
    for_each = each.value.o365_policy != null ? [each.value.o365_policy] : []

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

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_vpn_site.vpn_site](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_site) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_vpn_sites"></a> [vpn\_sites](#input\_vpn\_sites)

Description:   Map of objects for VPN Sites to deploy into the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

  The key is deliberately arbitrary to avoid issues with known after apply values. The value is an object, of which there can be multiple in the map:

  - `name`: Name for the VPN Site resource.
  - `virtual_hub_id`: Virtual hub ID.
  - `virtual_wan_id`: Virtual WAN ID.
  - `links`: List of links for the VPN Site, which includes:
    - `name`: Name for the link.
    - `bgp`: Optional BGP object for the link, which includes:
      - `asn`: ASN for the BGP.
      - `peering_address`: Peering address for the BGP.
    - `fqdn`: Optional FQDN for the link.
    - `ip_address`: Optional IP address for the link.
    - `provider_name`: Optional provider name for the link.
    - `speed_in_mbps`: Optional speed in Mbps for the link.
  - `address_cidrs`: Optional list of address CIDRs for the VPN Site. Must be set if `links.bgp` is not set.
  - `device_model`: Optional device model for the VPN Site.
  - `device_vendor`: Optional device vendor for the VPN Site.
  - `o365_policy`: Optional O365 policy object for the VPN Site, which includes:
    - `traffic_category`: Optional traffic category object for the O365 policy, which includes:
      - `allow_endpoint_enabled`: Optional boolean. Is allow endpoint enabled? The `Allow` endpoint is required for connectivity to specific O365 services and features, but are not as sensitive to network performance and latency as other endpoint types.
      - `default_endpoint_enabled`: Optional boolean. Is default endpoint enabled? The `Default` endpoint represents O365 services and dependencies that do not require any optimization, and can be treated by customer networks as normal Internet bound traffic.
      - `optimize_endpoint_enabled`: Optional boolean. Is optimize endpoint enabled? The `Optimize` endpoint is required for connectivity to every O365 service and represents the O365 scenario that is the most sensitive to network performance, latency, and availability.
  - `tags`: Optional tags to apply to the VPN Site resource.

  > Note: There can be multiple objects in this map, one for each VPN Site you wish to deploy into the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

Type:

```hcl
map(object({
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
  }))
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

### <a name="output_resource_object"></a> [resource\_object](#output\_resource\_object)

Description: Azure VPN Site object

### <a name="output_vpn_site_name"></a> [vpn\_site\_name](#output\_vpn\_site\_name)

Description: Azure VPN Site names

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->