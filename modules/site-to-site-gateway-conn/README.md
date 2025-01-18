<!-- BEGIN_TF_DOCS -->
# Basic example

This submodule deploys an Azure site-to-site connection between site-to-site Gateway and remote gateway in the Virtual Hub

```hcl
# Create a site to site vpn connection between a vpn gateway and a vpn site.
resource "azurerm_vpn_gateway_connection" "vpn_site_connection" {
  for_each = var.vpn_site_connection != null ? var.vpn_site_connection : {}

  name                      = each.value.name
  remote_vpn_site_id        = each.value.remote_vpn_site_id
  vpn_gateway_id            = each.value.vpn_gateway_id
  internet_security_enabled = try(each.value.internet_security_enabled, null)

  dynamic "vpn_link" {
    for_each = each.value.vpn_links != null && length(each.value.vpn_links) > 0 ? each.value.vpn_links : []

    content {
      name                                  = vpn_link.value.name
      vpn_site_link_id                      = vpn_link.value.vpn_site_link_id
      bandwidth_mbps                        = try(vpn_link.value.bandwidth_mbps, null)
      bgp_enabled                           = try(vpn_link.value.bgp_enabled, null)
      connection_mode                       = try(vpn_link.value.connection_mode, null)
      egress_nat_rule_ids                   = try(vpn_link.value.egress_nat_rule_ids, null)
      ingress_nat_rule_ids                  = try(vpn_link.value.ingress_nat_rule_ids, null)
      local_azure_ip_address_enabled        = try(vpn_link.value.local_azure_ip_address_enabled, null)
      policy_based_traffic_selector_enabled = try(vpn_link.value.policy_based_traffic_selector_enabled, null)
      protocol                              = try(vpn_link.value.protocol, null)
      ratelimit_enabled                     = try(vpn_link.value.ratelimit_enabled, null)
      route_weight                          = try(vpn_link.value.route_weight, null)
      shared_key                            = try(vpn_link.value.shared_key, null)

      dynamic "custom_bgp_address" {
        for_each = vpn_link.value.custom_bgp_address != null ? [vpn_link.value.custom_bgp_address] : []

        content {
          ip_address          = custom_bgp_address.value.ip_address
          ip_configuration_id = custom_bgp_address.value.ip_configuration_id
        }
      }
      dynamic "ipsec_policy" {
        for_each = vpn_link.value.ipsec_policy != null ? [vpn_link.value.ipsec_policy] : []

        content {
          dh_group                 = ipsec_policy.value.dh_group
          encryption_algorithm     = ipsec_policy.value.encryption_algorithm
          ike_encryption_algorithm = ipsec_policy.value.ike_encryption_algorithm
          ike_integrity_algorithm  = ipsec_policy.value.ike_integrity_algorithm
          integrity_algorithm      = ipsec_policy.value.integrity_algorithm
          pfs_group                = ipsec_policy.value.pfs_group
          sa_data_size_kb          = ipsec_policy.value.sa_data_size_kb
          sa_lifetime_sec          = ipsec_policy.value.sa_lifetime_sec
        }
      }
    }
  }
  dynamic "routing" {
    for_each = each.value.routing != null ? [each.value.routing] : []

    content {
      associated_route_table = routing.value.associated_route_table

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table != null ? [routing.value.propagated_route_table] : []

        content {
          route_table_ids = propagated_route_table.value.route_table_ids
          labels          = propagated_route_table.value.labels
        }
      }
    }
  }
  dynamic "traffic_selector_policy" {
    for_each = each.value.traffic_selector_policy != null ? [each.value.traffic_selector_policy] : []

    content {
      local_address_ranges  = traffic_selector_policy.value.local_address_ranges
      remote_address_ranges = traffic_selector_policy.value.remote_address_ranges
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

- [azurerm_vpn_gateway_connection.vpn_site_connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway_connection) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_vpn_site_connection"></a> [vpn\_site\_connection](#input\_vpn\_site\_connection)

Description: S2S VPN Site Connections parameter

Type:

```hcl
map(object({
    name               = string
    remote_vpn_site_id = string
    vpn_gateway_id     = string
    vpn_links = list(object({
      name                 = string
      egress_nat_rule_ids  = optional(list(string))
      ingress_nat_rule_ids = optional(list(string))
      # ID of the link to VPN site. Links are created in the VPN site module.
      vpn_site_link_id = string
      bandwidth_mbps   = optional(number)
      bgp_enabled      = optional(bool)
      connection_mode  = optional(string)

      ipsec_policy = optional(object({
        dh_group                 = string
        ike_encryption_algorithm = string
        ike_integrity_algorithm  = string
        encryption_algorithm     = string
        integrity_algorithm      = string
        pfs_group                = string
        sa_data_size_kb          = string
        sa_lifetime_sec          = string
      }))
      protocol                              = optional(string)
      ratelimit_enabled                     = optional(bool)
      route_weight                          = optional(number)
      shared_key                            = optional(string)
      local_azure_ip_address_enabled        = optional(bool)
      policy_based_traffic_selector_enabled = optional(bool)
      custom_bgp_address = optional(list(object({
        ip_address          = string
        ip_configuration_id = string
      })))
    }))
    internet_security_enabled = optional(bool)
    routing = optional(object({
      associated_route_table = string
      propagated_route_table = optional(object({
        route_table_ids = optional(list(string))
        labels          = optional(list(string))
      }))
      inbound_route_map_id  = optional(string)
      outbound_route_map_id = optional(string)
    }))
    traffic_selector_policy = optional(object({
      local_address_ranges  = string
      remote_address_ranges = string
    }))
  }))
```

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_resource"></a> [resource](#output\_resource)

Description: Azure VPN Connection resource

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Azure VPN Connection resource ID

### <a name="output_resource_object"></a> [resource\_object](#output\_resource\_object)

Description: Azure VPN Connection resource object

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->