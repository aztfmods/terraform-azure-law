provider "azurerm" {
  features {}
}

locals {
  naming = {
    company = "cn"
    env     = "p"
    region  = "weu"
  }
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"
  rgs = {
    laws = {
      name     = "rg-${local.naming.company}-laws-${local.naming.env}-${local.naming.region}"
      location = "westeurope"
    }
  }
}

module "law" {
  source = "../../"

  naming = {
    company = local.naming.company
    env     = local.naming.env
    region  = local.naming.region
  }

  laws = {
    demo = {
      location      = module.global.groups.laws.location
      resourcegroup = module.global.groups.laws.name
      sku           = "PerGB2018"
      retention     = 30
      solutions     = ["ContainerInsights", "VMInsights", "AzureActivity"]
    }
  }
  depends_on = [module.global]
}