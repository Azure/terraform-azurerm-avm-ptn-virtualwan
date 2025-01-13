variable "vpn_gateways" {
  type = map(object({
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
  default     = {}
  description = <<DESCRIPTION
  Map of objects for S2S VPN Gateways to deploy into the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

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

  DESCRIPTION
}
