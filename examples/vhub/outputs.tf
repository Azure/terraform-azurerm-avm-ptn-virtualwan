output "test" {
  value = {
    resource_id                             = module.vwan_with_vhub.resource_id
    name                                    = module.vwan_with_vhub.name
    firewall_resource_ids                   = module.vwan_with_vhub.firewall_resource_ids
    firewall_resource_names                 = module.vwan_with_vhub.firewall_resource_names
    firewall_private_ip_address             = module.vwan_with_vhub.firewall_private_ip_address
    firewall_public_ip_addresses            = module.vwan_with_vhub.firewall_public_ip_addresses
    firewall_resource_ids_by_hub_key        = module.vwan_with_vhub.firewall_resource_ids_by_hub_key
    firewall_resource_names_by_hub_key      = module.vwan_with_vhub.firewall_resource_names_by_hub_key
    firewall_private_ip_address_by_hub_key  = module.vwan_with_vhub.firewall_private_ip_address_by_hub_key
    firewall_public_ip_addresses_by_hub_key = module.vwan_with_vhub.firewall_public_ip_addresses_by_hub_key
    virtual_hub_resource_ids                = module.vwan_with_vhub.virtual_hub_resource_ids
    virtual_hub_resource_names              = module.vwan_with_vhub.virtual_hub_resource_names
  }
}
