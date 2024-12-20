output "resource_id" {
  description = "Azure ExpressRoute Gateway resource ID"
  value       = azurerm_express_route_gateway.express_route_gateway.id
}

output "resource" {
  description = "Azure ExpressRoute Gateway resource name"
  value       = azurerm_express_route_gateway.express_route_gateway.name
}