module "vwan_with_vhub" {
  source                         = "../../"
  resource_group_name            = "tvmVwanRg"
  create_resource_group          = true
  location                       = "australiaeast"
  virtual_wan_name               = "tvmVwan"
  allow_branch_to_branch_traffic = true
  type                           = "Standard"
  virtual_wan_tags = {
    environment = "dev"
    deployment  = "terraform"
  }
}
