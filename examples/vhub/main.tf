resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

locals {
  location            = "australiaeast"
  resource_group_name = "rg-avm-vwan-${random_pet.vvan_name.id}"
  tags = {
    environment = "avm-vwan-testing"
    deployment  = "terraform"
  }
  virtual_hub_key  = "aue-vhub"
  virtual_hub_name = "vhub-avm-vwan-${random_pet.vvan_name.id}"
  virtual_wan_name = "vwan-avm-vwan-${random_pet.vvan_name.id}"
}

module "vwan_with_vhub" {
  source                         = "../../"
  create_resource_group          = true
  resource_group_name            = local.resource_group_name
  location                       = local.location
  virtual_wan_name               = local.virtual_wan_name
  disable_vpn_encryption         = false
  allow_branch_to_branch_traffic = true
  type                           = "Standard"
  virtual_wan_tags               = local.tags
  virtual_hubs = {
    (local.virtual_hub_key) = {
      name           = local.virtual_hub_name
      location       = local.location
      resource_group = local.resource_group_name
      address_prefix = "10.0.0.0/24"
      tags           = local.tags
    }
  }
}

output "test" {
  value = {
    resource_id                              = module.vwan_with_vhub.resource_id
    name                                     = module.vwan_with_vhub.name
    firewall_resource_ids                    = module.vwan_with_vhub.firewall_resource_ids
    firewall_resource_names                  = module.vwan_with_vhub.firewall_resource_names
    firewall_private_ip_addresses            = module.vwan_with_vhub.firewall_ip_addresses
    firewall_public_ip_addresses             = module.vwan_with_vhub.firewall_public_ip_addresses
    firewall_resource_ids_by_hub_key         = module.vwan_with_vhub.firewall_resource_ids_by_hub_key
    firewall_resource_names_by_hub_key       = module.vwan_with_vhub.firewall_resource_names_by_hub_key
    firewall_private_ip_addresses_by_hub_key = module.vwan_with_vhub.firewall_private_ip_addresses_by_hub_key
    firewall_public_ip_addresses_by_hub_key  = module.vwan_with_vhub.firewall_public_ip_addresses_by_hub_key
    virtual_hub_resource_ids                 = module.vwan_with_vhub.virtual_hub_resource_ids
    virtual_hub_resource_names               = module.vwan_with_vhub.virtual_hub_resource_names
  }
}
