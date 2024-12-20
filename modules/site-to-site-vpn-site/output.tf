output "vpn_site_id" {
  description = "Azure VPN Site ID"
  value       = azurerm_vpn_site.vpn_site.id
}

output "vpn_site_name" {
  description = "Azure VPN Site names"
  value       = azurerm_vpn_site.vpn_site.name
}

output "links" {
  description = "Azure VPN Site links"
  value       = azurerm_vpn_site.vpn_site.link
}
