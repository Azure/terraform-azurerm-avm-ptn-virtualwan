output "location" {
  description = "Virtual Hub Location"
  value       = { for key, hub in azurerm_virtual_hub.virtual_hub : key => hub.location }
}

output "resource" {
  description = "Virtual Hub"
  value       = { for key, hub in azurerm_virtual_hub.virtual_hub : key => hub }
}

output "resource_group_name" {
  description = "Resource Group Name"
  value       = { for key, hub in azurerm_virtual_hub.virtual_hub : key => hub.resource_group_name }
}

output "resource_id" {
  description = "Virtual Hub ID"
  value       = { for key, hub in azurerm_virtual_hub.virtual_hub : key => hub.id }
}

output "resource_ids" {
  description = "Virtual Hub IDs"
  value       = { for key, hub in azurerm_virtual_hub.virtual_hub : key => hub.id }
}

output "resource_names" {
  description = "Virtual Hub Names"
  value       = { for key, hub in azurerm_virtual_hub.virtual_hub : key => hub.name }
}

output "resource_object" {
  description = "Virtual Hub Object"
  value = {
    for key, hub in azurerm_virtual_hub.virtual_hub : key => {
      id             = hub.id
      name           = hub.name
      location       = hub.location
      resource_group = hub.resource_group_name
      sku            = hub.sku
      tags           = hub.tags
    }
  }
}
