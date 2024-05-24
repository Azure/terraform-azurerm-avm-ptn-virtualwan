output "er_gw_id" {
  description = "ExpressRoute Gateway ID"
  value       = var.expressroute_gateways != null ? [for gw in azurerm_express_route_gateway.express_route_gateway : gw.id] : null
}

output "fw" {
  description = "Firewall Name"
  value       = var.firewalls != null ? [for firewall in azurerm_firewall.fw : firewall.name] : null
}

output "p2s_vpn_gw_id" {
  description = "P2S VPN Gateway ID"
  value       = var.p2s_gateways != null ? [for gw in azurerm_vpn_gateway.vpn_gateway : gw.id] : null
}

output "resource" {
  description = "The full resource outputs."
  value       = merge(azurerm_virtual_wan.virtual_wan, azurerm_virtual_hub.virtual_hub)
}

output "resource_group_name" {
  description = "Resource Group Name"
  value       = local.resource_group_name
}

output "resource_id" {
  description = "Virtual WAN ID"
  value       = azurerm_virtual_wan.virtual_wan != null ? azurerm_virtual_wan.virtual_wan.id : var.virtual_hubs != null ? [for hub in azurerm_virtual_hub.virtual_hub : hub.id] : null
}

output "s2s_vpn_gw" {
  description = "S2S VPN Gateway Objects"
  value       = var.vpn_gateways != null ? [for gw in azurerm_vpn_gateway.vpn_gateway : gw] : null
}

output "s2s_vpn_gw_id" {
  description = "S2S VPN Gateway ID"
  value       = var.vpn_gateways != null ? [for gw in azurerm_vpn_gateway.vpn_gateway : gw.id] : null
}

output "virtual_hub_id" {
  description = "Virtual Hub ID"
  value       = var.virtual_hubs != null ? [for hub in azurerm_virtual_hub.virtual_hub : hub.id] : null
}

output "virtual_wan_id" {
  description = "Virtual WAN ID"
  value       = azurerm_virtual_wan.virtual_wan != null ? azurerm_virtual_wan.virtual_wan.id : null
}
