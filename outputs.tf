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
  value       = azurerm_virtual_wan.virtual_wan != null ? [azurerm_virtual_wan.virtual_wan.id] : var.virtual_hubs != null ? [for hub in azurerm_virtual_hub.virtual_hub : hub.id] : []
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

output "azure_firewall_resource_ids" {
  description = "A map of Azure Firewall resource IDs with the map keys of the `firewalls` variable."
  value       = var.firewalls != null ? { for key, value in azurerm_firewall.fw : key => value.id } : null
}

output "expressroute_gateway_resource_ids" {
  description = "A map of expressRoute Gateway IDs with the map keys of the `expressroute_gateways` variable."
  value       = var.expressroute_gateways != null ? { for key, value in azurerm_express_route_gateway.express_route_gateway : key => value.id } : null
}

output "p2s_vpn_gw_resource_ids" {
  description = "A map of point to site VPN gateway names with the map keys of the `p2s_gateways` variable."
  value       = var.p2s_gateways != null ? { for key, value in azurerm_vpn_gateway.vpn_gateway : key => value.id } : null
}

output "vpn_gateway_resource_ids" {
  description = "A map of Azure VPN Gateway resource IDs with the map keys of the `vpn_gateways` variable."
  value       = var.vpn_gateways != null ? { for key, value in azurerm_vpn_gateway.vpn_gateway : key => value.id } : null
}

output "virtual_hub_resource_ids" {
  description = "A map of Azure Virtual Hub resource IDs with the map keys of the `virtual_hubs` variable."
  value       = var.virtual_hubs != null ? { for key, value in azurerm_virtual_hub.virtual_hub : key => value.id } : null
}

output "azure_firewall_resource_names" {
  description = "A map of Azure Firewall resource names with the map keys of the `firewalls` variable."
  value       = var.firewalls != null ? { for key, value in azurerm_firewall.fw : key => value.id } : null
}

output "expressroute_gateway_resource_names" {
  description = "A map of expressRoute Gateway names with the map keys of the `expressroute_gateways` variable."
  value       = var.expressroute_gateways != null ? { for key, value in azurerm_express_route_gateway.express_route_gateway : key => value.id } : null
}

output "p2s_vpn_gw_resource_names" {
  description = "A map of point to site VPN gateway names with the map keys of the `p2s_gateways` variable."
  value       = var.p2s_gateways != null ? { for key, value in azurerm_vpn_gateway.vpn_gateway : key => value.id } : null
}

output "vpn_gateway_resource_names" {
  description = "A map of Azure VPN Gateway resource names with the map keys of the `vpn_gateways` variable."
  value       = var.vpn_gateways != null ? { for key, value in azurerm_vpn_gateway.vpn_gateway : key => value.id } : null
}

output "virtual_hub_resource_names" {
  description = "A map of Azure Virtual Hub resource names with the map keys of the `virtual_hubs` variable."
  value       = var.virtual_hubs != null ? { for key, value in azurerm_virtual_hub.virtual_hub : key => value.id } : null
}