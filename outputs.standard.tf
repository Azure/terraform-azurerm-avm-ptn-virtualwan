output "resource_id" {
  description = "Virtual WAN ID"
  value       = azurerm_virtual_wan.virtual_wan.id
}

output "name" {
  description = "Virtual WAN Name"
  value       = azurerm_virtual_wan.virtual_wan.name
}

output "firewall_resource_ids" {
  description = "A map of Azure Firewall resource IDs with the map keys of the `firewalls` variable."
  value       = module.firewalls.resource_ids
}

output "firewall_resource_names" {
  description = "A map of Azure Firewall resource names with the map keys of the `firewalls` variable."
  value       = module.firewalls.resource_names
}

output "firewall_private_ip_address" {
  description = "A map of Azure Firewall private IP address with the map keys of the `firewalls` variable."
  value       = module.firewalls.private_ip_address
}

output "firewall_public_ip_addresses" {
  description = "A map of Azure Firewall public IP addresses with the map keys of the `firewalls` variable."
  value       = module.firewalls.public_ip_addresses
}

output "firewall_resource_ids_by_hub_key" {
  description = "A map of Azure Firewall resource IDs with the map keys of the `firewalls` variable."
  value       = { for key, value in var.firewalls : value.virtual_hub_key => module.firewalls.resource_ids[key] }
}

output "firewall_resource_names_by_hub_key" {
  description = "A map of Azure Firewall resource names with the map keys of the `firewalls` variable."
  value       = { for key, value in var.firewalls : value.virtual_hub_key => module.firewalls.resource_names[key] }
}

output "firewall_private_ip_address_by_hub_key" {
  description = "A map of Azure Firewall private IP address with the map keys of the `firewalls` variable."
  value       = { for key, value in var.firewalls : value.virtual_hub_key => module.firewalls.private_ip_address[key] }
}

output "firewall_public_ip_addresses_by_hub_key" {
  description = "A map of Azure Firewall public IP addresses with the map keys of the `firewalls` variable."
  value       = { for key, value in var.firewalls : value.virtual_hub_key => module.firewalls.public_ip_addresses[key] }
}

output "virtual_hub_resource_ids" {
  description = "A map of Azure Virtual Hub resource IDs with the map keys of the `virtual_hubs` variable."
  value       = module.virtual_hubs.resource_ids
}

output "virtual_hub_resource_names" {
  description = "A map of Azure Virtual Hub resource names with the map keys of the `virtual_hubs` variable."
  value       = module.virtual_hubs.resource_names
}
