output "resource_id" {
  description = "Azure ExpressRoute Connection resource ID"
  value       = azurerm_express_route_connection.er_connection.id
}

output "resource" {
  description = "Azure ExpressRoute Connection resource"
  value       = azurerm_express_route_connection.er_connection
}