variable "vpn_sites" {
  type = object({
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
  description = "Azure Virtual WAN vpn sites"
}
