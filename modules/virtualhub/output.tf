output "resource_id" {
  description = "Virtual Hub ID"
  value       = azurerm_virtual_hub.virtual_hub.id
}

output "resource" {
  description = "Virtual Hub"
  value       = azurerm_virtual_hub.virtual_hub
}

output "location" {
  description = "Virtual Hub Location"
  value       = azurerm_virtual_hub.virtual_hub.location
}

output "resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_virtual_hub.virtual_hub.resource_group_name
}
