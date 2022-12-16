provider "azurerm" {
  features {}
}

module "global" {
  source = "github.com/aztfmods/module-azurerm-global"

  company = "cn"
  env     = "p"
  region  = "weu"

  rgs = {
    demo = { location = "westeurope" }
  }
}

module "law" {
  source = "../../"

  company = module.global.company
  env     = module.global.env
  region  = module.global.region

  laws = {
    demo = {
      location      = module.global.groups.demo.location
      resourcegroup = module.global.groups.demo.name
      sku           = "PerGB2018"
      retention     = 90
      solutions     = ["ContainerInsights", "VMInsights", "AzureActivity"]
    }
  }
  depends_on = [module.global]
}