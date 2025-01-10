output "resource_id" {
  description = "Azure VPN Site ID"
  value       = var.vpn_sites != null ? { for k, v in azurerm_vpn_site.vpn_site : k => v.id } : {}
}

output "vpn_site_name" {
  description = "Azure VPN Site names"
  value       = var.vpn_sites != null ? keys(azurerm_vpn_site.vpn_site) : []
}

output "links" {
  description = "Azure VPN Site links"
  value       = var.vpn_sites != null ? { for k, v in azurerm_vpn_site.vpn_site : k => v.link } : {}
}

output "resource" {
  description = "Azure VPN Site resource"
  value       = var.vpn_sites != null ? { for k, v in azurerm_vpn_site.vpn_site : k => v } : {}
}

output "resource_object" {
  description = "Azure VPN Site object"
  value = var.vpn_sites != null ? { for k, v in azurerm_vpn_site.vpn_site : k => {
    location       = v.location
    name           = v.name
    id             = v.id
    resource_group = v.resource_group_name
    virtual_wan_id = v.virtual_wan_id
    address_cidrs  = try(v.address_cidrs, null)
    device_model   = try(v.device_model, null)
    device_vendor  = try(v.device_vendor, null)
    tags           = try(v.tags, {})
    links          = v.link != null && length(v.link) > 0 ? v.link : []
    o365_policy    = v.o365_policy != null ? [v.o365_policy] : []
  } } : {}
}
