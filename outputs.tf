output "resource_group_name" {
  value       = local.resource_group_name
  description = "Resource Group Name"
}

output "virtual_wan_id" {
  value       = azurerm_virtual_wan.virtual_wan != null ? azurerm_virtual_wan.virtual_wan.id : null
  description = "Virtual WAN ID"
}

output "virtual_hub_id" {
  value       = var.virtual_hubs != null ? [for hub in azurerm_virtual_hub.virtual_hub : hub.id] : null
  description = "Virtual Hub ID"
}

output "s2s_vpn_gw_id" {
  value       = var.vpn_gateways != null ? [for gw in azurerm_vpn_gateway.vpn_gateway : gw.id] : null
  description = "S2S VPN Gateway ID"
}

output "s2s_vpn_gw" {
  value       = var.vpn_gateways != null ? [for gw in azurerm_vpn_gateway.vpn_gateway : gw] : null
  description = "S2S VPN Gateway Objects"
}

output "p2s_vpn_gw_id" {
  value       = var.p2s_gateways != null ? [for gw in azurerm_vpn_gateway.vpn_gateway : gw.id] : null
  description = "P2S VPN Gateway ID"
}

output "er_gw_id" {
  value       = var.expressroute_gateways != null ? [for gw in azurerm_express_route_gateway.express_route_gateway : gw.id] : null
  description = "ExpressRoute Gateway ID"
}

output "fw" {
  value       = var.firewalls != null ? [for firewall in azurerm_firewall.fw : firewall.name] : null
  description = "Firewall Name"
}
