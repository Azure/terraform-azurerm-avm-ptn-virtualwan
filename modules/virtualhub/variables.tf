variable "address_prefix" {
  type        = string
  description = "Address prefix of the Virtual Hub"
  nullable    = false
}

variable "location" {
  type        = string
  description = "Virtual Hub location"
  nullable    = false
}

variable "name" {
  type        = string
  description = "Virtual Hub name"
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "Virtual HUB Resource group name"

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

variable "virtual_wan_id" {
  type        = string
  description = "Virtual WAN ID"
  nullable    = false

  validation {
    condition     = length(var.virtual_wan_id) > 3
    error_message = "Virtual wan ID must be supplied."
  }
}

variable "hub_routing_preference" {
  type        = string
  default     = "None"
  description = "Hub routing preference"
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}
