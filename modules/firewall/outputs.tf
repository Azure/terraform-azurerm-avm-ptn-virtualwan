output "azure_firewall_resource_names" {
  description = "Azure Firewall resource name"
  value       = var.firewalls != null ? [for fw in azurerm_firewall.fw : fw.name] : []
}

output "diagnostic_settings_resource_ids" {
  description = "Value of the diagnostic settings resource ID for Azure Firewall"
  value       = { for key, value in azurerm_monitor_diagnostic_setting.this : key => value.id }
}

output "private_ip_address" {
  description = "Azure Firewall IP addresses"
  value       = var.firewalls != null ? { for key, value in azurerm_firewall.fw : key => value.virtual_hub[0].private_ip_address } : null
}

output "public_ip_addresses" {
  description = "Azure Firewall IP addresses"
  value       = var.firewalls != null ? { for key, value in azurerm_firewall.fw : key => value.virtual_hub[0].public_ip_addresses } : null
}

output "resource" {
  description = "Azure Firewall resource"
  value       = var.firewalls != null ? azurerm_firewall.fw : {}
}

output "resource_id" {
  description = "Azure Firewall resource ID"
  value       = var.firewalls != null ? [for fw in azurerm_firewall.fw : fw.id] : []
}

output "resource_ids" {
  description = "Azure Firewall resource IDs"
  value       = var.firewalls != null ? { for key, value in azurerm_firewall.fw : key => value.id } : null
}

output "resource_names" {
  description = "Azure Firewall resource names"
  value       = var.firewalls != null ? { for key, value in azurerm_firewall.fw : key => value.name } : null
}

output "resource_object" {
  description = "Azure Firewall resource object"
  value = var.firewalls != null ? {
    for key, fw in azurerm_firewall.fw : key => {
      id          = fw.id
      name        = fw.name
      virtual_hub = fw.virtual_hub
    }
  } : {}
}
