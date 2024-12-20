variable "bgp_route_translation_for_nat_enabled" {
  type        = bool
  description = "BGP route translation for NAT enabled"
}

variable "bgp_settings" {
  type = object({
    asn = number
    instance_0_bgp_peering_address = optional(object({
      custom_ips = optional(list(string))
    }))
    instance_1_bgp_peering_address = optional(object({
      custom_ips = optional(list(string))
    }))
    peer_weight = number
  })
  description = "BGP settings of the VPN Gateway"
}

variable "location" {
  type        = string
  description = "Location of the VPN Gateway"
  nullable    = false
}

variable "name" {
  type        = string
  description = "Name of the VPN Gateway"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name of the VPN Gateway"
  nullable    = false
}

variable "routing_preference" {
  type        = string
  description = "Routing preference of the VPN Gateway"
}

variable "scale_unit" {
  type        = number
  description = "Scale unit of the VPN Gateway"
}

variable "virtual_hub_id" {
  type        = string
  description = "Virtual Hub ID of the VPN Gateway"
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(optional) Tags of the VPN Gateway"
}
