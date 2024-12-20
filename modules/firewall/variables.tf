variable "location" {
  type        = string
  description = "Virtual Hub location"
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

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "name" {
  type        = string
  description = "Firewall name"
  nullable = false
}

variable "sku_name" {
  type        = string
  description = "SKU name"
  nullable = false
}

variable "sku_tier" {
  type        = string
  description = "SKU tier"
  nullable = false  
}

variable "firewall_policy_id" {
  type        = string
  description = "Firewall policy ID" 
}

variable "virtual_hub_id" {
  type        = string
  description = "Virtual Hub ID"
  nullable = false  
}