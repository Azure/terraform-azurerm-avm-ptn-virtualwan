resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

resource "random_pet" "law" {
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

resource "azurerm_resource_group" "law" {
  location = local.location
  name     = "rg-${random_pet.law.id}"
}

resource "azurerm_log_analytics_workspace" "test" {
  location            = local.location
  name                = "law-${random_pet.law.id}"
  resource_group_name = azurerm_resource_group.law.name
  sku                 = "PerGB2018"
}

module "vwan_with_vhub" {
  source = "../../"

  location                       = local.location
  resource_group_name            = local.resource_group_name
  virtual_wan_name               = local.virtual_wan_name
  allow_branch_to_branch_traffic = true
  create_resource_group          = true
  diagnostic_settings_azure_firewall = {
    (local.virtual_hub_key) = {
      diags = {
        workspace_resource_id = azurerm_log_analytics_workspace.test.id
      }
    }
  }
  disable_vpn_encryption = false
  firewalls = {
    (local.virtual_hub_key) = {
      name                 = "fw-${local.virtual_hub_name}"
      sku_name             = "AZFW_Hub"
      sku_tier             = "Standard"
      firewall_policy_id   = null
      vhub_public_ip_count = 1
      virtual_hub_key      = local.virtual_hub_key
      tags                 = local.tags
    }
  }
  type = "Standard"
  virtual_hubs = {
    (local.virtual_hub_key) = {
      name           = local.virtual_hub_name
      location       = local.location
      resource_group = local.resource_group_name
      address_prefix = "10.0.0.0/24"
      tags           = local.tags
    }
  }
  virtual_wan_tags = local.tags
}
