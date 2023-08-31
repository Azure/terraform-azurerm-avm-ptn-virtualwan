terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = ">=1.8.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0"
    }
  }
}
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

