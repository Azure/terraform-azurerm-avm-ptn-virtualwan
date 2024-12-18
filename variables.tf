variable "allow_branch_to_branch_traffic" {
  type        = bool
  description = "Switch to flip VWAN branch to branch traffic"
}

# Resource group parameters
variable "location" {
  type        = string
  description = "Virtual WAN location"
  nullable    = false
}

variable "resource_group_name" {
  type        = string
  description = "Virtual WAN Resource group name"

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

# Virtual Wan parameters
variable "virtual_wan_name" {
  type        = string
  description = "Virtual WAN name"
  nullable    = false

  validation {
    condition     = length(var.virtual_wan_name) > 3
    error_message = "At least one virtual wan must be defined."
  }
}

variable "create_resource_group" {
  type        = bool
  default     = false
  description = "If true will create a resource group, otherwise will use the existing resource group supplied in resource_group_name"
}

variable "disable_vpn_encryption" {
  type        = bool
  default     = false
  description = "Switch to flip VWAN vpn encryption"
}

variable "er_circuit_connections" {
  type = map(object({
    name                                 = string
    express_route_gateway_key            = string
    express_route_circuit_peering_id     = string
    authorization_key                    = optional(string)
    enable_internet_security             = optional(bool)
    express_route_gateway_bypass_enabled = optional(bool)
    routing = optional(object({
      associated_route_table_id  = optional(string)
      associated_route_table_key = optional(string)
      propagated_route_table = optional(object({
        route_table_ids  = optional(list(string))
        route_table_keys = optional(list(string))
        labels           = optional(list(string))
      }))
      inbound_route_map_id  = optional(string)
      outbound_route_map_id = optional(string)
    }))
    routing_weight = optional(number)
  }))
  default     = {}
  description = "Mapping object to link ER circuits to ER Gateways for the creation of connection"
}

# Express Route Gateway parameters
variable "expressroute_gateways" {
  type = map(object({
    name                          = string
    virtual_hub_key               = string
    tags                          = optional(map(string))
    allow_non_virtual_wan_traffic = optional(bool)
    scale_units                   = optional(number, 1)
  }))
  default     = {}
  description = "Express Route Gateway parameters"
}

# Azure Firewall
variable "firewalls" {
  type = map(object({
    virtual_hub_key      = string
    sku_name             = string
    sku_tier             = string
    name                 = optional(string)
    dns_servers          = optional(list(string))
    firewall_policy_id   = optional(string)
    private_ip_ranges    = optional(list(string))
    threat_intel_mode    = optional(string, "Alert")
    zones                = optional(list(string))
    vhub_public_ip_count = optional(string)
    tags                 = optional(map(string))
    default_ip_configuration = optional(object({
      name = optional(string)
      public_ip_config = optional(object({
        name       = optional(set(string))
        zones      = optional(set(string))
        ip_version = optional(string)
        sku_tier   = optional(string, "Regional")
      }))
    }))
    management_ip_configuration = optional(object({
      name                 = string
      subnet_id            = string
      public_ip_address_id = string
    }))
    ip_configuration = optional(object({
      name                 = string
      subnet_id            = string
      public_ip_address_id = string
    }))
  }))
  default     = {}
  description = "Azure Firewall parameters"
}

variable "office365_local_breakout_category" {
  type        = string
  default     = "None"
  description = "Specifies the Office365 local breakout category. Possible values include: Optimize, OptimizeAndAllow, All, None. Defaults to None "
}

variable "p2s_gateway_vpn_server_configurations" {
  type = map(object({
    name                     = string
    virtual_hub_key          = string
    vpn_authentication_types = list(string)
    tags                     = optional(map(string))
    client_root_certificate = optional(object({
      name             = string
      public_cert_data = string
    }))
    azure_active_directory_authentication = optional(object({
      audience = string
      issuer   = string
      tenant   = string
    }))
    ipsec_policy = optional(object({
      dh_group               = string
      ike_encryption         = string
      ike_integrity          = string
      ipsec_encryption       = string
      ipsec_integrity        = string
      pfs_group              = string
      sa_lifetime_seconds    = string
      sa_data_size_kilobytes = string
    }))
    vpn_protocols = optional(list(string))
  }))
  default     = {}
  description = "P2S VPN Gateway server configuration parameters"
}

# P2S gateway parameters
variable "p2s_gateways" {
  type = map(object({
    name                                     = string
    virtual_hub_key                          = string
    tags                                     = optional(map(string))
    p2s_gateway_vpn_server_configuration_key = string
    connection_configuration = object({
      name = string
      vpn_client_address_pool = object({
        address_prefixes = list(string)
      })
    })
    routing_preference                  = optional(string)
    scale_unit                          = number
    dns_servers                         = optional(list(string))
    routing_preference_internet_enabled = optional(bool)
  }))
  default     = {}
  description = "P2S VPN Gateway parameters"
}

variable "resource_group_tags" {
  type        = map(string)
  default     = {}
  description = "Virtual WAN Resource group tags"
}

# Routing intent for virutal hubs
variable "routing_intents" {
  type = map(object({
    name            = string
    virtual_hub_key = string
    routing_policies = list(object({
      name                  = string
      destinations          = list(string)
      next_hop_firewall_key = string
    }))
  }))
  default     = {}
  description = "Routing intent for virutal hubs"
  nullable    = false
}

# General tags for all resources in pattern
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "type" {
  type        = string
  default     = "Standard"
  description = "Type of the virtual WAN"
}

variable "virtual_hub_route_tables" {
  type = map(object({
    name            = string
    virtual_hub_key = string
    labels          = optional(list(string))
    routes = optional(map(object({
      name                = string
      destinations        = list(string)
      destinations_type   = string
      next_hop            = optional(string)
      vnet_connection_key = optional(string)
      next_hop_type       = string
    })))
  }))
  default     = {}
  description = <<-EOT
 - `name` - (Required) The name which should be used for Virtual Hub Route Table. Changing this forces a new resource to be created.
 - `virtual_hub_key` - (Required) The key of the Virtual Hub within which this route table should be created. Changing this forces a new resource to be created.
 - `labels` - (Optional) List of labels associated with this route table.
 - `routes` - (Optional) A map of routes in the Virtual Hub Route Table. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
  - `name` - (Required) The name which should be used for this route.
  - `destinations` - (Required) A list of destination addresses for this route.
  - `destinations_type` - (Required) The type of destinations. Possible values are CIDR, ResourceId and Service.
  - `next_hop` - (Optional) The next hop's resource ID. Required if `vnet_connection_key` is not defined.
  - `vnet_connection_key` - (Optional) The next hop vnet connection's key. Required if `next_hop` is not defined.
  - `next_hop_type` - (Optional) The type of next hop. Currently the only possible value is ResourceId. Defaults to ResourceId.
EOT
}

variable "virtual_hubs" {
  type = map(object({
    name                   = string
    location               = string
    resource_group         = optional(string, null)
    address_prefix         = string
    tags                   = optional(map(string))
    hub_routing_preference = optional(string)
  }))
  default     = {}
  description = "Virtual Hub parameters"
}

# Azure virtual network connections
variable "virtual_network_connections" {
  type = map(object({
    name                      = string
    virtual_hub_key           = string
    remote_virtual_network_id = string
    internet_security_enabled = optional(bool, false)
    routing = optional(object({
      associated_route_table_id = string
      propagated_route_table = optional(object({
        route_table_ids = optional(list(string), [])
        labels          = optional(list(string), [])
      }))
      static_vnet_route = optional(object({
        name                = optional(string)
        address_prefixes    = optional(list(string), [])
        next_hop_ip_address = optional(string)
      }))
    }))
  }))
  default     = {}
  description = "Azure virtual network connections"
  nullable    = false
}

variable "virtual_wan_tags" {
  type        = map(string)
  default     = {}
  description = "Virtual WAN tags"
}

# VPN Gateway parameters
variable "vpn_gateways" {
  type = map(object({
    name                                  = string
    virtual_hub_key                       = string
    tags                                  = optional(map(string))
    bgp_route_translation_for_nat_enabled = optional(bool)
    bgp_settings = optional(object({
      asn = number
      instance_0_bgp_peering_address = optional(object({
        custom_ips = list(string)
      }))
      instance_1_bgp_peering_address = optional(object({
        custom_ips = list(string)
      }))
      peer_weight = number
    }))
    routing_preference = optional(string)
    scale_unit         = optional(number)
  }))
  default     = {}
  description = "S2S VPN Gateway parameters"
}

variable "vpn_site_connections" {
  type = map(object({
    name                = string
    vpn_gateway_key     = string
    remote_vpn_site_key = string
    vpn_links = list(object({
      name                 = string
      egress_nat_rule_ids  = optional(list(string))
      ingress_nat_rule_ids = optional(list(string))
      # Index of the link on the vpn gateway
      vpn_site_link_number = number
      bandwidth_mbps       = optional(number)
      bgp_enabled          = optional(bool)
      connection_mode      = optional(string)

      ipsec_policy = optional(object({
        dh_group                 = string
        ike_encryption_algorithm = string
        ike_integrity_algorithm  = string
        encryption_algorithm     = string
        integrity_algorithm      = string
        pfs_group                = string
        sa_data_size_kb          = string
        sa_lifetime_sec          = string
      }))
      protocol                              = optional(string)
      ratelimit_enabled                     = optional(bool)
      route_weight                          = optional(number)
      shared_key                            = optional(string)
      local_azure_ip_address_enabled        = optional(bool)
      policy_based_traffic_selector_enabled = optional(bool)
      custom_bgp_address = optional(list(object({
        ip_address          = string
        ip_configuration_id = string
      })))
    }))
    internet_security_enabled = optional(bool)
    routing = optional(object({
      associated_route_table = string
      propagated_route_table = optional(object({
        route_table_ids = optional(list(string))
        labels          = optional(list(string))
      }))
      inbound_route_map_id  = optional(string)
      outbound_route_map_id = optional(string)
    }))
    traffic_selector_policy = optional(object({
      local_address_ranges  = string
      remote_address_ranges = string
    }))
  }))
  default     = {}
  description = "S2S VPN Site Connections parameter"
}

variable "vpn_sites" {
  type = map(object({
    name = string
    # Name of the virtual hub
    virtual_hub_key = string
    links = list(object({
      name = string
      bgp = optional(object({
        asn             = number
        peering_address = string
      }))
      fqdn          = optional(string)
      ip_address    = optional(string)
      provider_name = optional(string)
      speed_in_mbps = optional(number)
      }
    ))
    address_cidrs = optional(list(string))
    device_model  = optional(string)
    device_vendor = optional(string)
    o365_policy = optional(object({
      traffic_category = object({
        allow_endpoint_enabled    = optional(bool)
        default_endpoint_enabled  = optional(bool)
        optimize_endpoint_enabled = optional(bool)
      })
    }))
    tags = optional(map(string))
  }))
  default     = {}
  description = "S2S VPN Sites parameter"
}
