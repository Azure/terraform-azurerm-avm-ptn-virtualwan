terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0"
    }
  }
}
provider "azurerm" {
  features {
  }
}

locals {
  location            = "australiaeast"
  resource_group_name = "tvmVwanRg"
  tags = {
    environment = "avm-vwan-testing"
  }
  nsg_name = "avm-vwan-nsg"
  vnet01 = {
    name          = "avm-vwan-vnet01"
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
  vwan = {
    name                           = "avm-vwan"
    location                       = local.location
    disable_vpn_encryption         = false
    create_resource_group          = false
    allow_branch_to_branch_traffic = true
    type                           = "Standard"
    tags = {
      environment = "avm-vwan-testing"
    }
  }
  vhubs = {
    aue-vhub = {
      name           = "aue_vhub"
      location       = "australiaeast"
      resource_group = "demo-vwan-rsg"
      address_prefix = "192.168.0.0/24"
      tags = {
        "location" = "AUE"
      }
    }
  }
  vnet_connections = {
    aue-vnet = {
      name                      = "aue-vnet-conn"
      virtual_hub_name          = "aue-vhub"
      internet_security_enabled = true
    }
  }
}

resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = local.resource_group_name
  tags     = local.tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = local.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet01.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = local.vnet01.address_space
  dns_servers         = local.vnet01.dns_servers

  subnet {
    name           = local.vnet01.subnet1.name
    address_prefix = local.vnet01.subnet1.address_prefix
  }

  subnet {
    name           = local.vnet01.subnet2.name
    address_prefix = local.vnet01.subnet2.address_prefix
    security_group = azurerm_network_security_group.nsg.id
  }

  depends_on = [azurerm_network_security_group.nsg]

  tags = local.tags
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
  virtual_hubs = {
    aue-vhub = local.vhubs.aue-vhub
  }
  virtual_network_connections = {
    aue-vnet = {
      name                      = local.vnet_connections.aue-vnet.name
      virtual_hub_name          = local.vnet_connections.aue-vnet.virtual_hub_name
      remote_virtual_network_id = azurerm_virtual_network.vnet.id
      internet_security_enabled = local.vnet_connections.aue-vnet.internet_security_enabled
    }
  }
  depends_on = [azurerm_resource_group.rg, azurerm_virtual_network.vnet]
}
