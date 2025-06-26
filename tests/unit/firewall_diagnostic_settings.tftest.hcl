mock_provider "azurerm" {
  mock_resource "azurerm_virtual_hub" {
    defaults = {
      id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualHubs/virtualHubName"
    }
  }
  mock_resource "azurerm_virtual_wan" {
    defaults = {
      id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualWans/virtualWanName"
    }
  }
  mock_resource "azurerm_firewall" {
    defaults = {
      id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/azureFirewalls/firewallName"
    }
  }
}

mock_provider "random" {}
mock_provider "modtm" {}


variables {
  location                       = "australiaeast"
  resource_group_name            = "rg-test"
  virtual_wan_name               = "vwan-test"
  allow_branch_to_branch_traffic = true
  create_resource_group          = true
  type                           = "Standard"
  virtual_wan_tags = {
    environment = "test"
    deployment  = "terraform"
  }
  virtual_hubs = {
    test = {
      name           = "testhub"
      location       = "australiaeast"
      resource_group = "rg-test"
      address_prefix = "10.0.0.0/24"
    }
  }
  firewalls = {
    test = {
      name                 = "fw-testhub"
      sku_name             = "AZFW_VNet"
      sku_tier             = "Standard"
      firewall_policy_id   = null
      vhub_public_ip_count = 1
      virtual_hub_key      = "test"
      zones                = []
    }
  }
  diagnostic_settings_azure_firewall = {
    test = {
      diags = {
        workspace_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.OperationalInsights/workspaces/test-workspace"
      }
    }
  }
}

run "test" {
  command = apply

  assert {
    error_message = "Workspace resource ID should be in diagnostic settings azure firewall"
    condition     = can(module.firewalls.diagnostic_settings_resource_ids["test-diags"])
  }
}
