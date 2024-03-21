output "s2s_vpn_gw" {
  value       = [for gw in module.vwan_with_vhub.s2s_vpn_gw : gw]
  description = "S2S VPN GW"
}
