output "s2s_vpn_gw" {
  description = "S2S VPN GW"
  value       = [for gw in module.vwan_with_vhub.s2s_vpn_gw : gw]
}
