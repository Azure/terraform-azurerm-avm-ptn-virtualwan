module "vpn_gateway" {
  source = "./modules/site-to-site-gateway"

  vpn_gateways = {
    for key, value in local.vpn_gateways : key => {
      name                                  = value.name
      resource_group_name                   = module.virtual_hubs.resource_object[value.virtual_hub_key].resource_group
      location                              = module.virtual_hubs.resource_object[value.virtual_hub_key].location
      virtual_hub_id                        = module.virtual_hubs.resource_object[value.virtual_hub_key].id
      bgp_route_translation_for_nat_enabled = value.bgp_route_translation_for_nat_enabled
      scale_unit                            = value.scale_unit
      routing_preference                    = value.routing_preference
      bgp_settings                          = value.bgp_settings
      tags                                  = value.tags
    }
  }
}

moved {
  from = azurerm_vpn_gateway.vpn_gateway
  to   = module.vpn_gateway.azurerm_vpn_gateway.vpn_gateway
}
