variable "location" {
  type        = string
  description = "Virtual Hub location"
  nullable    = false
}

variable "name" {
  type        = string
  description = "ExpressRoute Gateway name"
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

variable "virtual_hub_id" {
  type        = string
  description = "Virtual Hub ID"
  nullable    = false
}

variable "scale_units" {
  type        = number
  default     = 2
  description = "Scale units of the ExpressRoute Gateway"
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}
