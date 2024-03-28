mock_provider "azurerm" {
  mock_resource "azurerm_virtual_wan" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vwantest/providers/Microsoft.Network/virtualWans/tester"
    }
  }
  mock_resource "azurerm_virtual_hub" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vwantest/providers/Microsoft.Network/virtualHubs/tester"
    }
  }
  mock_resource "azurerm_express_route_gateway" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vwantest/providers/Microsoft.Network/expressRouteGateways/tester"
    }
  }
}

run "express_route_connection_with_no_routing_is_successful" {
  variables {
    create_resource_group          = true
    resource_group_name            = "rg-avm-vwan"
    location                       = "australiaeast"
    virtual_wan_name               = "vhub-avm-vwan"
    disable_vpn_encryption         = false
    allow_branch_to_branch_traffic = true
    type                           = "Standard"
    virtual_wan_tags = {
      environment = "avm-vwan-testing"
      deployment  = "terraform"
    }
    virtual_hubs = {
      "aue-vhub" = {
        name           = "vhub-avm-vwan"
        location       = "australiaeast"
        resource_group = "rg-avm-vwan"
        address_prefix = "10.0.0.0/24"
        tags = {
          environment = "avm-vwan-testing"
          deployment  = "terraform"
        }
      }
    }
    expressroute_gateways = {
      aue-vhub-er-gw = {
        name            = "eg-avm-vwan"
        virtual_hub_key = "aue-vhub"
        scale_units     = 1
      }
    }
    er_circuit_connections = {
      example1 = {
        name                             = "testing123"
        express_route_gateway_key        = "aue-vhub-er-gw"
        express_route_circuit_peering_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vwantest/providers/Microsoft.Network/expressRouteCircuits/tester/peerings/AzurePrivatePeering"
        routing_weight                   = 1
      }
    }
  }

  assert {
    condition     = length(azurerm_express_route_connection.er_connection["example1"].routing) == 0
    error_message = "Routing blocks should not exist"
  }
}

run "express_route_connection_with_routing_is_successful" {
  variables {
    create_resource_group          = true
    resource_group_name            = "rg-avm-vwan"
    location                       = "australiaeast"
    virtual_wan_name               = "vhub-avm-vwan"
    disable_vpn_encryption         = false
    allow_branch_to_branch_traffic = true
    type                           = "Standard"
    virtual_wan_tags = {
      environment = "avm-vwan-testing"
      deployment  = "terraform"
    }
    virtual_hubs = {
      "aue-vhub" = {
        name           = "vhub-avm-vwan"
        location       = "australiaeast"
        resource_group = "rg-avm-vwan"
        address_prefix = "10.0.0.0/24"
        tags = {
          environment = "avm-vwan-testing"
          deployment  = "terraform"
        }
      }
    }
    expressroute_gateways = {
      aue-vhub-er-gw = {
        name            = "eg-avm-vwan"
        virtual_hub_key = "aue-vhub"
        scale_units     = 1
      }
    }
    er_circuit_connections = {
      example1 = {
        name                             = "testing123"
        express_route_gateway_key        = "aue-vhub-er-gw"
        express_route_circuit_peering_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vwantest/providers/Microsoft.Network/expressRouteCircuits/tester/peerings/AzurePrivatePeering"
        routing = {
          associated_route_table_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/vwantest/providers/Microsoft.Network/virtualHubs/tester/hubRouteTables/tester"
        }
        routing_weight = 1
      }
    }
  }

  assert {
    condition     = length(azurerm_express_route_connection.er_connection["example1"].routing) == 1
    error_message = "Routing blocks should exist"
  }
}
