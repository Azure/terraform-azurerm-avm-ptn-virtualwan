resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

locals {
  location                        = "australiaeast"
  network_security_group_name     = "nsg-avm-vwan-${random_pet.vvan_name.id}"
  resource_group_name             = "rg-avm-vwan-${random_pet.vvan_name.id}"
  tags                            = local.tags
  virtual_hub_key                 = "aue-vhub"
  virtual_hub_name                = "vhub-avm-vwan-${random_pet.vvan_name.id}"
  virtual_network_connection_name = "vnet-conn-avm-vwan-${random_pet.vvan_name.id}"
  virtual_network_name            = "vnet-avm-vwan-${random_pet.vvan_name.id}"
  virtual_wan_name                = "vwan-avm-vwan-${random_pet.vvan_name.id}"
}

locals {
  vhubs = {
    (local.virtual_hub_key) = {
      name           = local.virtual_hub_name
      location       = local.location
      resource_group = local.resource_group_name
      address_prefix = "192.168.0.0/24"
      tags           = local.tags
    }
  }
  vnet01 = {
    name          = local.virtual_network_name
    address_space = ["10.0.0.0/16"]
    dns_servers   = ["10.0.0.4", "10.0.0.5"]
    subnet1 = {
      name           = "subnet1"
      address_prefix = "10.0.1.0/24"

    }
    subnet2 = {
      name           = "subnet2"
      address_prefix = "10.0.2.0/24"
    }
  }
  vnet_connections = {
    aue-vnet = {
      virtual_network_connection_name = "vnet-conn-avm-vwan-${random_pet.vvan_name.id}"
      name                            = local.virtual_network_connection_name
      virtual_hub_key                 = local.virtual_hub_key
      remote_virtual_network_id       = azurerm_virtual_network.vnet.id
      internet_security_enabled       = true
    }
  }
  vwan = {
    name                           = local.virtual_wan_name
    location                       = local.location
    disable_vpn_encryption         = false
    create_resource_group          = false
    allow_branch_to_branch_traffic = true
    type                           = "Standard"
    tags = {
      environment = "avm-vwan-testing"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = local.resource_group_name
  tags     = local.tags
}

resource "azurerm_network_security_group" "nsg" {
  location            = azurerm_resource_group.rg.location
  name                = local.network_security_group_name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = local.vnet01.address_space
  location            = azurerm_resource_group.rg.location
  name                = local.vnet01.name
  resource_group_name = azurerm_resource_group.rg.name
  dns_servers         = local.vnet01.dns_servers
  tags                = local.tags

  subnet {
    address_prefix = local.vnet01.subnet1.address_prefix
    name           = local.vnet01.subnet1.name
  }
  subnet {
    address_prefix = local.vnet01.subnet2.address_prefix
    name           = local.vnet01.subnet2.name
    security_group = azurerm_network_security_group.nsg.id
  }
}

module "vwan_with_vhub" {
  source                         = "../../"
  create_resource_group          = local.vwan.create_resource_group
  resource_group_name            = azurerm_resource_group.rg.name
  location                       = azurerm_resource_group.rg.location
  virtual_wan_name               = local.vwan.name
  disable_vpn_encryption         = local.vwan.disable_vpn_encryption
  allow_branch_to_branch_traffic = local.vwan.allow_branch_to_branch_traffic
  type                           = local.vwan.type
  virtual_wan_tags               = local.vwan.tags
  virtual_hubs                   = local.vhubs
  virtual_network_connections    = local.vnet_connections
}
