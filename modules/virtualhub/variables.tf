variable "virtual_hubs" {
  type = map(object({
    name                                   = string
    location                               = string
    resource_group                         = optional(string, null)
    address_prefix                         = string
    tags                                   = optional(map(string))
    virtual_wan_id                         = string
    hub_routing_preference                 = optional(string, "ExpressRoute")
    virtual_router_auto_scale_min_capacity = optional(number, 2)
  }))
  default     = {}
  description = <<DESCRIPTION
  Map of objects for Virtual Hubs to deploy into the Virtual WAN.

  The key is deliberately arbitrary to avoid issues with known after apply values. The value is an object, of which there can be multiple in the map:

  - `name`: Name for the Virtual Hub resource.
  - `location`: Location for the Virtual Hub resource.
  - `resource_group`: Optional resource group name to deploy the Virtual Hub into. If not specified, the Virtual Hub will be deployed into the resource group specified in the variable `resource_group_name`, e.g. the same as the Virtual WAN itself.
  - `address_prefix`: Address prefix for the Virtual Hub. Recommend using a `/23` CIDR block.
  - `tags`: Optional tags to apply to the Virtual Hub resource.
  - `hub_routing_preference`: Optional hub routing preference for the Virtual Hub. Possible values are: `ExpressRoute`, `ASPath`, `VpnGateway`. Defaults to `ExpressRoute`. See https://learn.microsoft.com/azure/virtual-wan/hub-settings#routing-preference for more information.
  - `virtual_router_auto_scale_min_capacity`: Optional minimum capacity for the Virtual Router auto scale. Defaults to `2`. See https://learn.microsoft.com/azure/virtual-wan/hub-settings#capacity for more information.

  > Note: There can be multiple objects in this map, one for each Virtual Hub you wish to deploy into the Virtual WAN. Multiple Virtual Hubs in the same region/location can be deployed into the same Virtual WAN also.

  DESCRIPTION
}