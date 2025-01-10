<!-- BEGIN_TF_DOCS -->
# Basic example

This submodule deploys an Azure Firewall in the Virtual Hub to make it secured vHUB.

```hcl
resource "azurerm_firewall" "fw" {
  for_each = var.firewalls != null ? var.firewalls : {}

  location            = each.value.location
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier
  firewall_policy_id  = each.value.firewall_policy_id
  tags                = try(each.value.tags, {})

  virtual_hub {
    virtual_hub_id  = each.value.virtual_hub_id
    public_ip_count = each.value.vhub_public_ip_count
  }
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.7)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.108)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.108)

## Resources

The following resources are used by this module:

- [azurerm_firewall.fw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_firewalls"></a> [firewalls](#input\_firewalls)

Description:   
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

Type:

```hcl
map(object({
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
```

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_azure_firewall_resource_names"></a> [azure\_firewall\_resource\_names](#output\_azure\_firewall\_resource\_names)

Description: Azure Firewall resource name

### <a name="output_resource"></a> [resource](#output\_resource)

Description: Azure Firewall resource

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Azure Firewall resource ID

### <a name="output_resource_object"></a> [resource\_object](#output\_resource\_object)

Description: Azure Firewall resource object

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->