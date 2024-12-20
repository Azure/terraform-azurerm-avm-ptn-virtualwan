output "vpn_gateway_id" {
  description = "Azure VPN Gateway resource ID"
  value       = azurerm_vpn_gateway.vpn_gateway.id
}

output "vpn_gateway_name" {
  description = "Azure VPN Gateway resource name"
  value       = azurerm_vpn_gateway.vpn_gateway.name
}

output "bgp_settings" {
  description = "Azure VPN Gateway object"
  value       = azurerm_vpn_gateway.vpn_gateway.bgp_settings
}

output "id" {
  description = "Azure VPN Gateway ID"
  value       = azurerm_vpn_gateway.vpn_gateway.id
}

output "resource_id" {
  description = "Azure VPN Gateway ID"
  value       = azurerm_vpn_gateway.vpn_gateway.id
}

output "resource" {
  description = "Azure VPN Gateway"
  value       = azurerm_vpn_gateway.vpn_gateway
}