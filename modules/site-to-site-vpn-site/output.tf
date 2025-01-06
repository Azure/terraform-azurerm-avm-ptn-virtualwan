output "resource_id" {
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

output "resource" {
  description = "Azure VPN Site resource"
  value       = azurerm_vpn_site.vpn_site
}
