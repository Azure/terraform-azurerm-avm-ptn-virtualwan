locals {
  module_name = "authorization-roleassignment"
  module_type = "res"
  telem_arm_deployment_name = substr(
    format(
      "%s.%s.%s.v%s.%s",
      local.telem_puid,
      local.module_type,
      substr(local.module_name, 0, 30),
      replace(local.module_version, ".", "-"),
      local.telem_random_hex
    ),
    0,
    64
  )
  telem_arm_template_content = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "variables": {},
  "resources": [],
  "outputs": {
    "telemetry": {
      "type": "String",
      "value": "For more information, see https://aka.ms/avm/telemetry"
    }
  }
}
TEMPLATE
  telem_puid                 = "46d3xgtf"
  telem_random_hex           = can(random_id.telem[0].hex) ? random_id.telem[0].hex : ""
}
