output "resource_id" {
  description = "Azure VPN Connection resource ID"
  value       = var.vpn_site_connection != null ? { for key, value in azurerm_vpn_gateway_connection.vpn_site_connection : key => value.id } : {}
}

output "resource" {
  description = "Azure VPN Connection resource"
  value       = var.vpn_site_connection != null ? { for key, value in azurerm_vpn_gateway_connection.vpn_site_connection : key => value } : {}
}

output "resource_object" {
  description = "Azure VPN Connection resource object"
  value       = var.vpn_site_connection != null ? {
    for key, value in azurerm_vpn_gateway_connection.vpn_site_connection : key => {
      id               = value.id
      name             = value.name
      link             = value.vpn_link
    }
  } : {}
}