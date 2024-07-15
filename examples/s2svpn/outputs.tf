output "s2s_vpn_gw" {
  description = "S2S VPN GW"
  value       = module.vwan_with_vhub.vpn_gateway_resource_ids
}
