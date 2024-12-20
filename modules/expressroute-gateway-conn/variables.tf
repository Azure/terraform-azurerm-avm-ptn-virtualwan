variable "express_route_circuit_peering_id" {
  type        = string
  description = "Express Route Circuit Peering ID"
  nullable    = false
}

variable "express_route_gateway_id" {
  type        = string
  description = "Express Route Gateway ID"
  nullable    = false
}

variable "name" {
  type        = string
  description = "ExpressRoute Gateway Connection name"
  nullable    = false
}

variable "authorization_key" {
  type        = string
  default     = null
  description = "Authorization key for the Express Route Connection"
}

variable "enable_internet_security" {
  type        = bool
  default     = false
  description = "Enable internet security for the Express Route Connection"
}

variable "routing" {
  type = map(object({
    associated_route_table_id = string
    inbound_route_map_id      = string
    outbound_route_map_id     = string
    propagated_route_table = map(object({
      labels          = list(string)
      route_table_ids = list(string)
    }))
  }))
  default     = null
  description = "Routing configuration for the Express Route Connection"
}

variable "routing_weight" {
  type        = number
  default     = 0
  description = "Routing weight for the Express Route Connection"
}
