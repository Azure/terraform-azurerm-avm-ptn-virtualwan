variable "expressroute_gateways" {
  type = map(object({
    name                          = string
    virtual_hub_id                = string
    location                      = string
    resource_group_name           = string
    tags                          = optional(map(string))
    allow_non_virtual_wan_traffic = optional(bool, false)
    scale_units                   = optional(number, 1)
  }))
  default     = {}
  description = <<DESCRIPTION

Map of objects for Express Route Gateways to deploy into the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

The key is deliberately arbitrary to avoid issues with known after apply values. The value is an object, of which there can be multiple in the map:

- `name`: Name for the ExpressRoute Gateway to deploy in the Virtual WAN Virtual Hub.
- `virtual_hub_id`: The object ID of the virtual hub.
- `tags`: Optional tags to apply to the ExpressRoute Gateway resource.
- `allow_non_virtual_wan_traffic`: Optional boolean to configures this gateway to accept traffic from non Virtual WAN networks. Defaults to `false`.
- `scale_units`: Optional number of scale units for the ExpressRoute Gateway. Defaults to `1`. See: https://learn.microsoft.com/azure/virtual-wan/virtual-wan-expressroute-about#expressroute-gateway-performance for more information on scale units.

> Note: There can be multiple objects in this map, one for each ExpressRoute Gateway you wish to deploy into the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

  DESCRIPTION
}
