output "vpn_gateway_id" {
  description = "Azure VPN Gateway resource ID"
  value       = var.vpn_gateways != null ? [for vpn_gateway in azurerm_vpn_gateway.vpn_gateway : vpn_gateway.id] : null
}

output "vpn_gateway_name" {
  description = "Azure VPN Gateway resource name"
  value       = var.vpn_gateways != null ? [for vpn_gateway in azurerm_vpn_gateway.vpn_gateway : vpn_gateway.name] : null
}

output "bgp_settings" {
  description = "Azure VPN Gateway object"
  value       = var.vpn_gateways != null ? [for vpn_gateway in azurerm_vpn_gateway.vpn_gateway : vpn_gateway.bgp_settings] : null
}

output "id" {
  description = "Azure VPN Gateway ID"
  value       = var.vpn_gateways != null ? [for vpn_gateway in azurerm_vpn_gateway.vpn_gateway : vpn_gateway.id] : null
}

output "resource_id" {
  description = "Azure VPN Gateway ID"
  value       = var.vpn_gateways != null ? [for vpn_gateway in azurerm_vpn_gateway.vpn_gateway : vpn_gateway.id] : null
}

output "resource" {
  description = "Azure VPN Gateway"
  value       = var.vpn_gateways != null ? [for vpn_gateway in azurerm_vpn_gateway.vpn_gateway : vpn_gateway] : null
}

output "resource_object" {
  description = "Azure VPN Gateway object"
  value = var.vpn_gateways != null ? { for key, vpn_gateway in azurerm_vpn_gateway.vpn_gateway : key => {
    id           = vpn_gateway.id
    name         = vpn_gateway.name
    bgp_settings = vpn_gateway.bgp_settings
  } } : null
}
