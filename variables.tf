# Resource group parameters
variable "location" {
  type        = string
  description = "Virtual WAN location"
}

variable "create_resource_group" {
  type        = bool
  description = "If true will create a resource group, otherwise will use the existing resource group supplied in resource_group_name"
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "Virtual WAN Resource group name"
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

variable "resource_group_tags" {
  type        = map(string)
  description = "Virtual WAN Resource group tags"
  default     = {}
}

# General tags for all resources
variable "tags" {
  type        = map(string)
  description = "Overall tags"
  default     = {}
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

variable "disable_vpn_encryption" {
  type        = bool
  description = "Switch to flip VWAN vpn encryption"
  default     = false
}

variable "allow_branch_to_branch_traffic" {
  type        = bool
  description = "Switch to flip VWAN branch to branch traffic"
}

variable "type" {
  type        = string
  description = "Type of the virtual WAN"
  default     = "Standard"
}

variable "office365_local_breakout_category" {
  type        = string
  description = "Specifies the Office365 local breakout category. Possible values include: Optimize, OptimizeAndAllow, All, None. Defaults to None "
  default     = "None"
}

variable "virtual_wan_tags" {
  type        = map(string)
  description = "Virtual WAN tags"
  default     = {}
}

variable "virtual_hubs" {
  type = map(object({
    name           = string
    location       = string
    resource_group = optional(string, null)
    address_prefix = string
    tags           = optional(map(string))
  }))
  description = "Virtual Hub parameters"
  default     = {}
}

# VPN Gateway parameters
variable "vpn_gateways" {
  type = map(object({
    name = string
    # Name of the virtual hub
    virtual_hub                           = string
    tags                                  = optional(map(string))
    bgp_route_translation_for_nat_enabled = optional(bool)
    bgp_settings = optional(object({
      asn                            = number
      instance_0_bgp_peering_address = optional(string)
      instance_1_bgp_peering_address = optional(string)
      peer_weight                    = number
    }))
    routing_preference = optional(string)
    scale_unit         = optional(number)
  }))
  description = "S2S VPN Gateway parameters"
  default     = {}
}

variable "vpn_sites" {
  type = map(object({
    name = string
    # Name of the virtual hub
    virtual_hub_name = string
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
  description = "S2S VPN Sites parameter"
  default     = {}
}

variable "vpn_site_connections" {
  type = map(object({
    name = string
    # Name of the virtual hub
    vpn_gateway_name = string
    # Name of the vpn site
    remote_vpn_site_name = string
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
  description = "S2S VPN Site Connections parameter"
  default     = {}
}

# P2S gateway parameters
variable "p2s_gateways" {
  type = map(object({
    name                                      = string
    virtual_hub_name                          = string
    tags                                      = optional(map(string))
    p2s_gateway_vpn_server_configuration_name = string
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
  description = "P2S VPN Gateway parameters"
  default     = {}
}

variable "p2s_gateway_vpn_server_configurations" {
  type = map(object({
    name                     = string
    virtual_hub_name         = string
    vpn_authentication_types = list(string)
    tags                     = optional(map(string))
    client_root_certificate = object({
      name             = string
      public_cert_data = string
    })
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
  description = "P2S VPN Gateway server configuration parameters"
  default     = {}
}

# Express Route Gateway parameters
variable "expressroute_gateways" {
  type = map(object({
    name                          = string
    virtual_hub                   = string
    tags                          = optional(map(string))
    allow_non_virtual_wan_traffic = optional(bool)
    scale_units                   = number
  }))
  description = "Express Route Gateway parameters"
  default     = {}
}

variable "er_circuit_connections" {
  type = map(object({
    name                                 = string
    express_route_gateway_name           = string
    express_route_circuit_peering_id     = string
    authorization_key                    = optional(string)
    enable_internet_security             = optional(bool)
    express_route_gateway_bypass_enabled = optional(bool)
    routing = optional(object({
      associated_route_table_id = string
      propagated_route_table = optional(object({
        route_table_ids = optional(list(string))
        labels          = optional(list(string))
      }))
      inbound_route_map_id  = optional(string)
      outbound_route_map_id = optional(string)
    }))
    routing_weight = optional(number)
  }))
  description = "Mapping object to link ER circuits to ER Gateways for the creation of connection"
  default     = {}
}

# Azure Firewall
variable "firewalls" {
  type = map(object({
    virtual_hub_name     = string
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
  description = "Azure Firewall parameters"
  default     = {}
}

# Azure virtual network connections
variable "virtual_network_connections" {
  type = map(object({
    name                      = string
    virtual_hub_name          = string
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
  description = "Azure virtual network connections"
  default     = {}
  nullable    = false
}

# Routing intent for virutal hubs
variable "routing_intents" {
  type = map(object({
    name             = string
    virtual_hub_name = string
    routing_policies = list(object({
      name         = string
      destinations = list(string)
      next_hop     = string
    }))
  }))
  description = "Routing intent for virutal hubs"
  default     = {}
  nullable = false
}
