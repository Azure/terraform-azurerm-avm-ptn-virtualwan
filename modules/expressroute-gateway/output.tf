output "er_gateway_id" {
  description = "Azure ExpressRoute Gateway resource ID"
  value       = azurerm_express_route_gateway.express_route_gateway.id
}

output "er_gateway_name" {
  description = "Azure ExpressRoute Gateway resource name"
  value       = azurerm_express_route_gateway.express_route_gateway.name  
}