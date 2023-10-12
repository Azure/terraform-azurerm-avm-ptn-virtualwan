
resource "azurerm_resource_group" "rg" {
  name     = "onpremises-rg"
  location = "australiaeast"
}

# Create azure virtual  network
resource "azurerm_virtual_network" "vnet" {
  name                = "onpremises-vnet"
  address_space       = ["172.16.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create azure subnet
resource "azurerm_subnet" "gwsubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["172.16.1.0/24"]
}

# Create virtual machine subnet
resource "azurerm_subnet" "vm-subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["172.16.0.0/24"]
}

# Create public IP address
resource "azurerm_public_ip" "gw-ip" {
  name                = "onpremises-gw-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create virtual network gateway
resource "azurerm_virtual_network_gateway" "gw" {
  name                = "onpremises-gw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "VpnGw1"

  active_active = false
  enable_bgp    = true

  bgp_settings {
    asn = 65001
  }

  ip_configuration {
    name                          = "gw-ip-config"
    public_ip_address_id          = azurerm_public_ip.gw-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gwsubnet.id
  }
}

# Create local network gateway
resource "azurerm_local_network_gateway" "onpremiseslocalgw" {
  name                = "onpremises-localgw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  gateway_address = tolist(module.vwan_with_vhub.s2s_vpn_gw[0].bgp_settings[0].instance_0_bgp_peering_address[0].tunnel_ips)[1]
  bgp_settings {
    asn                 = module.vwan_with_vhub.s2s_vpn_gw[0].bgp_settings[0].asn
    bgp_peering_address = tolist(module.vwan_with_vhub.s2s_vpn_gw[0].bgp_settings[0].instance_0_bgp_peering_address[0].default_ips)[0]
    peer_weight         = 0
  }
}

# Create connection
resource "azurerm_virtual_network_gateway_connection" "onpremisesconnection" {
  name                = "onpremises-connection"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  virtual_network_gateway_id = azurerm_virtual_network_gateway.gw.id
  local_network_gateway_id   = azurerm_local_network_gateway.onpremiseslocalgw.id
  type                       = "IPsec"
  connection_protocol        = "IKEv2"
  routing_weight             = 10
  shared_key                 = random_password.shared_key.result
  enable_bgp                 = true
}

