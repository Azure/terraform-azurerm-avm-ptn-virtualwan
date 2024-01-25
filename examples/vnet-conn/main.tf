resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

locals {
  virtual_hub_key = "aue-vhub"
}

locals {
  location            = "australiaeast"
  nsg_name            = random_pet.vvan_name.id
  resource_group_name = random_pet.vvan_name.id
  tags = {
    environment = "avm-vwan-testing"
  }
  vhubs = {
    (local.virtual_hub_key) = {
      name           = random_pet.vvan_name.id
      location       = "australiaeast"
      resource_group = random_pet.vvan_name.id
      address_prefix = "192.168.0.0/24"
      tags = {
        "location" = "AUE"
      }
    }
  }
  vnet01 = {
    name          = random_pet.vvan_name.id
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
      name                      = random_pet.vvan_name.id
      virtual_hub_name          = local.virtual_hub_key
      remote_virtual_network_id = azurerm_virtual_network.vnet.id
      internet_security_enabled = true
    }
  }
  vwan = {
    name                           = random_pet.vvan_name.id
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
  name                = local.nsg_name
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
