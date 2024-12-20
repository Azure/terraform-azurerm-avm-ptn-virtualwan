module "vpn_gateway" {
  source = "./modules/site-to-site-gateway"

  for_each = local.vpn_gateways != null && length(local.vpn_gateways) > 0 ? local.vpn_gateways : {}

  location                              = module.virtual_hubs[each.value.virtual_hub_key].location
  name                                  = each.value.name
  resource_group_name                   = module.virtual_hubs[each.value.virtual_hub_key].resource_group_name
  virtual_hub_id                        = module.virtual_hubs[each.value.virtual_hub_key].virtual_hub_id
  bgp_route_translation_for_nat_enabled = try(each.value.bgp_route_translation_for_nat_enabled, null)
  bgp_settings                          = try(each.value.bgp_settings, null)
  routing_preference                    = try(each.value.routing_preference, null)
  scale_unit                            = try(each.value.scale_unit, null)
  tags                                  = try(each.value.tags, {})
}
# Create a vpn site. Sites represent the Physical locations (On-Premises) you wish to connect.
module "vpn_site" {
  source = "./modules/site-to-site-vpn-site"

  for_each = local.vpn_sites != null ? local.vpn_sites : {}
  vpn_sites = {
    location            = module.virtual_hubs[each.value.virtual_hub_key].location
    name                = each.value.name
    resource_group_name = module.virtual_hubs[each.value.virtual_hub_key].resource_group_name
    virtual_wan_id      = azurerm_virtual_wan.virtual_wan.id
    address_cidrs       = try(each.value.address_cidrs, null)
    device_model        = try(each.value.device_model, null)
    device_vendor       = try(each.value.device_vendor, null)
    tags                = try(each.value.tags, {})
    links               = try(each.value.links, null)
    o365_policy         = try(each.value.o365_policy, null)
  }
}
# Create a site to site vpn connection between a vpn gateway and a vpn site.
module "vpn_site_connection" {
  source = "./modules/site-to-site-gateway-conn"

  for_each = local.vpn_site_connections != null && length(local.vpn_site_connections) > 0 ? local.vpn_site_connections : {}
  vpn_site_connection = {
    name                      = each.value.name
    remote_vpn_site_id        = module.vpn_site[each.value.remote_vpn_site_key].vpn_site_id
    vpn_gateway_id            = module.vpn_gateway[each.value.vpn_gateway_key].id
    internet_security_enabled = try(each.value.internet_security_enabled, null)
    vpn_links                 = [
      for link in each.value.vpn_links : {
        name                 = link.name
        vpn_site_link_id     = module.vpn_site[link.vpn_site_key].links[link.vpn_site_link_number].id
        bandwidth_mbps       = try(link.bandwidth_mbps, null)
        bgp_enabled          = try(link.bgp_enabled, null)
        connection_mode      = try(link.connection_mode, null)
        egress_nat_rule_ids  = try(link.egress_nat_rule_ids, null)
        ingress_nat_rule_ids = try(link.ingress_nat_rule_ids, null)
        ipsec_policy         = try(link.ipsec_policy, null)
        protocol             = try(link.protocol, null)
        ratelimit_enabled    = try(link.ratelimit_enabled, null)
        route_weight         = try(link.route_weight, null)
        shared_key           = try(link.shared_key, null)
        local_azure_ip_address_enabled = try(link.local_azure_ip_address_enabled, null)
        policy_based_traffic_selector_enabled = try(link.policy_based_traffic_selector_enabled, null)
        custom_bgp_address   = try(link.custom_bgp_address, null)
      }
    ]
    routing                   = try(each.value.routing, null)
    traffic_selector_policy   = try(each.value.traffic_selector_policy, null)
  }
  depends_on = [ module.vpn_site, module.vpn_gateway ]
}
