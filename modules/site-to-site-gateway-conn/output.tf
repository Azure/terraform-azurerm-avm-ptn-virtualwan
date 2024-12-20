output "resource_id" {
  description = "Azure VPN Connection resource ID"
  value       = azurerm_vpn_gateway_connection.vpn_site_connection.id
}

output "resource" {
  description = "Azure VPN Connection resource"
  value       = azurerm_vpn_gateway_connection.vpn_site_connection
}