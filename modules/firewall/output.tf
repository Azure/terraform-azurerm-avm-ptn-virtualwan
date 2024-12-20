output "id" {
  description = "Azure Firewall resource ID"
  value       = azurerm_firewall.fw.id
}

output "azure_firewall_resource_names" {
  description = "Azure Firewall resource name"
  value       = azurerm_firewall.fw.name
}