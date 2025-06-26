variable "diagnostic_settings" {
  type = map(map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  })))
  default     = {}
  description = <<DESCRIPTION
  A map of diagnostic settings to create on the firewall. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

  The first map key is that of the Virtual Hub key, as defined in the `virtual_hubs` variable. The second map key is arbitrary to define multiple diagnostic settings on each firewall.

  - `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
  - `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
  - `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
  - `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
  - `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
  - `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
  - `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
  - `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
  - `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
  - `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
  DESCRIPTION
  nullable    = false

  validation {
    condition = alltrue(flatten(
      [
        for _, v in var.diagnostic_settings :
        [
          for _, v2 in v : contains(["Dedicated", "AzureDiagnostics"], v2.log_analytics_destination_type)
        ]
      ])
    )
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(flatten(
      [
        for _, v in var.diagnostic_settings :
        [
          for _, v2 in v :
          v2.workspace_resource_id != null || v2.storage_account_resource_id != null || v2.event_hub_authorization_rule_resource_id != null || v2.marketplace_partner_resource_id != null
        ]
      ])
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
}

variable "firewalls" {
  type = map(object({
    virtual_hub_id       = string
    sku_name             = optional(string, "AZFW_Hub")
    location             = string
    resource_group_name  = string
    sku_tier             = string
    name                 = string
    zones                = optional(list(number), [1, 2, 3])
    firewall_policy_id   = optional(string)
    vhub_public_ip_count = optional(string, null)
    tags                 = optional(map(string))
  }))
  default     = {}
  description = <<DESCRIPTION

Map of objects for Azure Firewall resources to deploy into the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

The key is deliberately arbitrary to avoid issues with known after apply values. The value is an object, of which there can be multiple in the map:

- `virtual_hub_key`: The arbitrary key specified in the map of objects variable called `virtual_hubs` for the object specifying the Virtual Hub you wish to deploy this Azure Firewall into.
- `sku_name`: The SKU name for the Azure Firewall. Possible values are: `AZFW_VNet`, `AZFW_Hub`. Defaults to `AZFW_Hub`.
- `sku_tier`: The SKU tier for the Azure Firewall. Possible values are: `Basic`, `Standard`, `Premium`.
- `name`: The name for the Azure Firewall resource.
- `zones`: Optional list of zones to deploy the Azure Firewall into. Defaults to `[1, 2, 3]`.
- `firewall_policy_id`: Optional Azure Firewall Policy Resource ID to associate with the Azure Firewall.
- `vhub_public_ip_count`: Optional number of public IP addresses to associate with the Azure Firewall.
- `tags`: Optional tags to apply to the Azure Firewall resource.

> Note: There can be multiple objects in this map, one for each Azure Firewall you wish to deploy into the Virtual WAN Virtual Hubs that have been defined in the variable `virtual_hubs`.

  DESCRIPTION
}
