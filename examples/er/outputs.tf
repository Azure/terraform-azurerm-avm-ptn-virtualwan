# expressroute gateway ids
output "expressroute_gateway_ids" {
  description = "A list of the ExpressRoute Gateway IDs."
  value       = module.vwan_with_vhub.ergw_id
}
