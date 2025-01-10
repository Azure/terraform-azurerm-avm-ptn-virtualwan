variable "vpn_sites" {
  type = map(object({
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
  description = <<DESCRIPTION
  Map of objects for VPN Sites to deploy into the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

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

  DESCRIPTION
}
