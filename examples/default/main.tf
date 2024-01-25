resource "random_pet" "vvan_name" {
  length    = 2
  separator = "-"
}

module "vwan_with_vhub" {
  source                         = "../../"
  resource_group_name            = random_pet.vvan_name.id
  create_resource_group          = true
  location                       = "australiaeast"
  virtual_wan_name               = random_pet.vvan_name.id
  allow_branch_to_branch_traffic = true
  type                           = "Standard"
  virtual_wan_tags = {
    environment = "dev"
    deployment  = "terraform"
  }
}
