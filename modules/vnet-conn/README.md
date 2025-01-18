<!-- BEGIN_TF_DOCS -->
# Basic example

This submodule deploys an Azure virtual network connection

```hcl
resource "azurerm_virtual_hub_connection" "hub_connection" {
  for_each = var.virtual_network_connections != null ? var.virtual_network_connections : {}

  name                      = each.value.name
  remote_virtual_network_id = each.value.remote_virtual_network_id
  virtual_hub_id            = each.value.virtual_hub_id
  internet_security_enabled = each.value.internet_security_enabled

  dynamic "routing" {
    for_each = each.value.routing != null ? [each.value.routing] : []

    content {
      associated_route_table_id = routing.value.associated_route_table_id

      dynamic "propagated_route_table" {
        for_each = routing.value.propagated_route_table != null ? [routing.value.propagated_route_table] : []

        content {
          labels          = propagated_route_table.value.labels
          route_table_ids = propagated_route_table.value.route_table_ids
        }
      }
      dynamic "static_vnet_route" {
        for_each = routing.value.static_vnet_route != null ? [routing.value.static_vnet_route] : []

        content {
          address_prefixes    = static_vnet_route.value.address_prefixes
          name                = static_vnet_route.value.name
          next_hop_ip_address = static_vnet_route.value.next_hop_ip_address
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

- [azurerm_virtual_hub_connection.hub_connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub_connection) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_virtual_network_connections"></a> [virtual\_network\_connections](#input\_virtual\_network\_connections)

Description:   Map of objects for Virtual Network connections to connect Virtual Networks to the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

  The key is deliberately arbitrary to avoid issues with known after apply values. The value is an object, of which there can be multiple in the map:

  - `name`: Name for the Virtual Network connection.
  - `virtual_hub_id`: The Resource ID of the Virtual Hub you wish to connect the Virtual Network to.
  - `remote_virtual_network_id`: The Resource ID of the Virtual Network you wish to connect to the Virtual Hub.
  - `internet_security_enabled`: Optional boolean to enable internet security for the connection, e.g. allow `0.0.0.0/0` route to be propagated to this connection.
  - `routing`: Optional routing configuration object for the connection, which includes:
    - `associated_route_table_id`: The resource ID of the Virtual Hub Route Table you wish to associate with this connection.
    - `propagated_route_table`: Optional configuration objection of propagated route table configuration, which includes:
      - `route_table_ids`: Optional list of resource IDs of the Virtual Hub Route Tables you wish to propagate this connections routes to.
      - `labels`: Optional list of labels you wish to propagate this connections routes to.
    - `static_vnet_route`: Optional configuration object for static VNet route configuration, which includes:
      - `name`: Optional name for the static VNet route.
      - `address_prefixes`: Optional list of address prefixes for the static VNet route.
      - `next_hop_ip_address`: Optional next hop IP address for the static VNet route.

  > Note: There can be multiple objects in this map, one for each Virtual Network connection you wish to connect to the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

Type:

```hcl
map(object({
    name                      = string
    virtual_hub_id            = string
    remote_virtual_network_id = string
    internet_security_enabled = optional(bool, false)
    routing = optional(object({
      associated_route_table_id = string
      propagated_route_table = optional(object({
        route_table_ids = optional(list(string), [])
        labels          = optional(list(string), [])
      }))
      static_vnet_route = optional(object({
        name                = optional(string)
        address_prefixes    = optional(list(string), [])
        next_hop_ip_address = optional(string)
      }))
    }))
  }))
```

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_resource"></a> [resource](#output\_resource)

Description: Virtual Hub

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Virtual Hub ID

### <a name="output_resource_object"></a> [resource\_object](#output\_resource\_object)

Description: Virtual Hub Object

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->