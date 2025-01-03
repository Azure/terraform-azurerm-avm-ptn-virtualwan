output "firewall_ip_addresses_by_firewall_key" {
  description = "A map of Azure Firewall IP addresses with the map keys of the firewalls."
  value = var.firewalls != null ? { for key, value in module.firewalls : key => {
    virtual_hub_key    = value.virtual_hub_key
    private_ip_address = module.firewalls[key].resource.virtual_hub[0].private_ip_address
  } } : null
}

output "firewall_ip_addresses_by_hub_key" {
  description = "A map of Azure Firewall IP addresses with the map keys of the hubs."
  value = var.firewalls != null ? { for key, value in module.firewalls : value.virtual_hub_key => {
    firewall_key       = key
    private_ip_address = module.firewalls[key].resource.virtual_hub[0].private_ip_address
  } } : null
}

output "p2s_vpn_gw_id" {
  description = "P2S VPN Gateway ID"
  value       = var.p2s_gateways != null ? [for gw in azurerm_point_to_site_vpn_gateway.p2s_gateway : gw.id] : null
}

output "p2s_vpn_gw_resource_ids" {
  description = "A map of point to site VPN gateway names with the map keys of the `p2s_gateways` variable."
  value       = var.p2s_gateways != null ? { for key, value in azurerm_point_to_site_vpn_gateway.p2s_gateway : key => value.id } : null
}

output "p2s_vpn_gw_resource_names" {
  description = "A map of point to site VPN gateway names with the map keys of the `p2s_gateways` variable."
  value       = var.p2s_gateways != null ? { for key, value in azurerm_point_to_site_vpn_gateway.p2s_gateway : key => value.id } : null
}

output "resource" {
  description = "The full resource outputs."
  value       = merge(azurerm_virtual_wan.virtual_wan, module.virtual_hubs)
}

output "resource_group_name" {
  description = "Resource Group Name"
  value       = local.resource_group_name
}

output "resource_id" {
  description = "Virtual WAN ID"
  value       = azurerm_virtual_wan.virtual_wan != null ? [azurerm_virtual_wan.virtual_wan.id] : var.virtual_hubs != null ? [for hub in module.virtual_hubs : hub.id] : []
}

output "s2s_vpn_gw" {
  description = "S2S VPN Gateway Objects"
  value       = var.vpn_gateways != null ? [for gw in module.vpn_gateway : gw] : null
}

output "s2s_vpn_gw_id" {
  description = "S2S VPN Gateway ID"
  value       = var.vpn_gateways != null ? [for gw in module.vpn_gateway : gw.id] : null
}

output "virtual_wan_id" {
  description = "Virtual WAN ID"
  value       = azurerm_virtual_wan.virtual_wan != null ? azurerm_virtual_wan.virtual_wan.id : null
}

output "vpn_gateway_resource_ids" {
  description = "A map of Azure VPN Gateway resource IDs with the map keys of the `vpn_gateways` variable."
  value       = var.vpn_gateways != null ? { for key, value in module.vpn_gateway : key => value.id } : null
}

output "vpn_gateway_resource_names" {
  description = "A map of Azure VPN Gateway resource names with the map keys of the `vpn_gateways` variable."
  value       = var.vpn_gateways != null ? { for key, value in module.vpn_gateway : key => value.id } : null
}
