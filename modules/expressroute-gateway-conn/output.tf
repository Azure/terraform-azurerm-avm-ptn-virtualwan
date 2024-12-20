output "er_connection_id" {
  description = "Azure ExpressRoute Connection resource ID"
  value       = azurerm_express_route_connection.er_connection.id  
}

output "er_connection_name" {
  description = "Azure ExpressRoute Connection resource name"
  value       = azurerm_express_route_connection.er_connection.name  
}