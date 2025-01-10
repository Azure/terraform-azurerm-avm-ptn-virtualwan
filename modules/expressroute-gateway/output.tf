output "resource_id" {
  description = "Azure ExpressRoute Gateway resource ID"
  value       = var.expressroute_gateways != null ? [for gateway in azurerm_express_route_gateway.express_route_gateway : gateway.id] : []
}

output "resource" {
  description = "Azure ExpressRoute Gateway resource name"
  value       = var.expressroute_gateways != null ? [for gateway in azurerm_express_route_gateway.express_route_gateway : gateway] : []
}
output "resource_object" {
  description = "Azure ExpressRoute Gateway resource object"
  value = var.expressroute_gateways != null ? {
    for key, gateway in azurerm_express_route_gateway.express_route_gateway : key => {
      id             = gateway.id
      name           = gateway.name
      location       = gateway.location
      resource_group = gateway.resource_group_name
      scale_units    = gateway.scale_units
    }
  } : {}
}
