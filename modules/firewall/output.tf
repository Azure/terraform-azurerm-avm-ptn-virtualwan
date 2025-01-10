output "azure_firewall_resource_names" {
  description = "Azure Firewall resource name"
  value       = var.firewalls != null ? [for fw in azurerm_firewall.fw : fw.name] : []
}

output "resource_id" {
  description = "Azure Firewall resource ID"
  value       = var.firewalls != null ? [for fw in azurerm_firewall.fw : fw.id] : []
}

output "resource" {
  description = "Azure Firewall resource"
  value       = var.firewalls != null ? azurerm_firewall.fw : {}
}

output "resource_object" {
  description = "Azure Firewall resource object"
  value = var.firewalls != null ? {
    for key, fw in azurerm_firewall.fw : key => {
      id   = fw.id
      name = fw.name
      virtual_hub = fw.virtual_hub
    }
  } : {}
}
