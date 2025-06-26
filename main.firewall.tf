module "firewalls" {
  source = "./modules/firewall"

  diagnostic_settings = var.diagnostic_settings_azure_firewall
  firewalls = {
    for key, value in var.firewalls : key => {
      location             = module.virtual_hubs.resource_object[value.virtual_hub_key].location
      name                 = value.name
      resource_group_name  = module.virtual_hubs.resource_object[value.virtual_hub_key].resource_group
      sku_name             = value.sku_name
      sku_tier             = value.sku_tier
      firewall_policy_id   = value.firewall_policy_id
      tags                 = value.tags
      virtual_hub_id       = module.virtual_hubs.resource_object[value.virtual_hub_key].id
      vhub_public_ip_count = value.vhub_public_ip_count
      zones                = value.zones
    }
  }
}

moved {
  from = azurerm_firewall.fw
  to   = module.firewalls.azurerm_firewall.fw
}
