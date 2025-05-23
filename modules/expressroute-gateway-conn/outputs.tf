output "resource" {
  description = "Azure ExpressRoute Connection resource"
  value       = var.er_circuit_connections != null ? [for connection in azurerm_express_route_connection.er_connection : connection] : []
}

output "resource_id" {
  description = "Azure ExpressRoute Connection resource ID"
  value       = var.er_circuit_connections != null ? [for connection in azurerm_express_route_connection.er_connection : connection.id] : []
}
