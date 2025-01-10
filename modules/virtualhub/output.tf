output "resource_id" {
  description = "Virtual Hub ID"
  value       = var.virtual_hubs != null ? [for hub in azurerm_virtual_hub.virtual_hub : hub.id] : []
}

output "resource" {
  description = "Virtual Hub"
  value       = var.virtual_hubs != null ? [for hub in azurerm_virtual_hub.virtual_hub : hub] : []
}

output "location" {
  description = "Virtual Hub Location"
  value       = var.virtual_hubs != null ? [for hub in azurerm_virtual_hub.virtual_hub : hub.location] : []
}

output "resource_group_name" {
  description = "Resource Group Name"
  value       = var.virtual_hubs != null ? [for hub in azurerm_virtual_hub.virtual_hub : hub.resource_group_name] : []
}

output "resource_object" {
  description = "Virtual Hub Object"
  value       = var.virtual_hubs != null ? {
    for key, hub in azurerm_virtual_hub.virtual_hub : key => {
      id               = hub.id
      name             = hub.name
      location         = hub.location
      resource_group   = hub.resource_group_name
      sku              = hub.sku
      tags             = hub.tags
    }
  } : {} 
}