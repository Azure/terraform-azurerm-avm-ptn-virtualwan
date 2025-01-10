variable "virtual_network_connections" {
  type = map(object({
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
  default     = {}
  description = <<DESCRIPTION
  Map of objects for Virtual Network connections to connect Virtual Networks to the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

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

  DESCRIPTION
  nullable    = false
}
