output "resource" {
  description = "Virtual Hub"
  value       = var.virtual_network_connections != null ? [for hub in azurerm_virtual_hub_connection.hub_connection : hub] : []
}

output "resource_id" {
  description = "Virtual Hub ID"
  value       = var.virtual_network_connections != null ? [for hub in azurerm_virtual_hub_connection.hub_connection : hub.id] : []
}

output "resource_object" {
  description = "Virtual Hub Object"
  value = var.virtual_network_connections != null ? {
    for key, hub in azurerm_virtual_hub_connection.hub_connection : key => {
      id   = hub.id
      name = hub.name
    }
  } : {}
}
