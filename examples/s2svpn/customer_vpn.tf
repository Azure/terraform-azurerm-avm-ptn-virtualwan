locals {
  on_prem_local_gateway_name   = "lg-avm-vwan-onprem-${random_pet.vvan_name.id}"
  on_prem_public_ip_name       = "pip-avm-vwan-onprem-${random_pet.vvan_name.id}"
  on_prem_resource_group_name  = "rg-avm-vwan-onprem-${random_pet.vvan_name.id}"
  on_prem_vnet_connection_name = "vc-avm-vwan-onprem-${random_pet.vvan_name.id}"
  on_prem_vnet_gateway_name    = "vg-avm-vwan-onprem-${random_pet.vvan_name.id}"
  on_prem_vnet_name            = "vnet-avm-vwan-onprem-${random_pet.vvan_name.id}"
}

resource "azurerm_resource_group" "rg" {
  location = local.location
  name     = local.on_prem_resource_group_name
}

# Create azure virtual  network
resource "azurerm_virtual_network" "vnet" {
  location            = azurerm_resource_group.rg.location
  name                = local.on_prem_vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["172.16.0.0/16"]
}

# Create azure subnet
resource "azurerm_subnet" "gwsubnet" {
  address_prefixes     = ["172.16.1.0/24"]
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

# Create virtual machine subnet
resource "azurerm_subnet" "vm_subnet" {
  address_prefixes     = ["172.16.0.0/24"]
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

# Create public IP address
resource "azurerm_public_ip" "gw_ip" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.rg.location
  name                = local.on_prem_public_ip_name
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  zones               = [1, 2, 3]
}

# Create virtual network gateway
resource "azurerm_virtual_network_gateway" "gw" {
  location            = azurerm_resource_group.rg.location
  name                = local.on_prem_vnet_gateway_name
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "VpnGw1AZ"
  type                = "Vpn"
  active_active       = false
  enable_bgp          = true
  vpn_type            = "RouteBased"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.gw_ip.id
    subnet_id                     = azurerm_subnet.gwsubnet.id
    name                          = "gw-ip-config"
    private_ip_address_allocation = "Dynamic"
  }
  bgp_settings {
    asn = 65001
  }
}

data "azurerm_public_ip" "gw_ip" {
  name                = local.on_prem_public_ip_name
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [azurerm_virtual_network_gateway.gw]
}

# Create local network gateway
resource "azurerm_local_network_gateway" "onpremiseslocalgw" {
  location            = azurerm_resource_group.rg.location
  name                = local.on_prem_local_gateway_name
  resource_group_name = azurerm_resource_group.rg.name
  gateway_address     = tolist(module.vwan_with_vhub.s2s_vpn_gw[0].bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips)[1]

  bgp_settings {
    asn                 = module.vwan_with_vhub.s2s_vpn_gw[0].bgp_settings[0].asn
    bgp_peering_address = tolist(module.vwan_with_vhub.s2s_vpn_gw[0].bgp_settings[0].instance_0_bgp_peering_address[0].default_ips)[0]
    peer_weight         = 0
  }
}

# Create connection
resource "azurerm_virtual_network_gateway_connection" "onpremisesconnection" {
  location                   = azurerm_resource_group.rg.location
  name                       = local.on_prem_vnet_connection_name
  resource_group_name        = azurerm_resource_group.rg.name
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.gw.id
  connection_protocol        = "IKEv2"
  enable_bgp                 = true
  local_network_gateway_id   = azurerm_local_network_gateway.onpremiseslocalgw.id
  routing_weight             = 10
  shared_key                 = random_password.shared_key.result
}

