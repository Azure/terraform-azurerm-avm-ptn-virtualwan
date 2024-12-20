output "virtual_hub_id" {
  description = "Virtual Hub ID"
  value       = azurerm_virtual_hub.virtual_hub.id
}

output "virtual_hub_names" {
  description = "Virtual Hub Name"
  value       = azurerm_virtual_hub.virtual_hub.name
}

output "location" {
  description = "Virtual Hub Location"
  value       = azurerm_virtual_hub.virtual_hub.location  
}

output "resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_virtual_hub.virtual_hub.resource_group_name
}
