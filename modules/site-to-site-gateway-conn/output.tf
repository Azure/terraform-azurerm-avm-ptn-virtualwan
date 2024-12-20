output "vpn_gateway_connection_id" {
  description = "Azure VPN Connection resource ID"
  value = azurerm_vpn_gateway_connection.vpn_site_connection.id
}

output "vpn_gateway_connection_name" {
  description = "Azure VPN Connection resource names"
  value = azurerm_vpn_gateway_connection.vpn_site_connection.name
}