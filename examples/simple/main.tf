provider "azurerm" {
  features {}
}

module "rgs" {
  source = "github.com/aztfmods/module-azurerm-rg"
  groups = {
    laws = { name = "rg-laws-weu", location = "westeurope" }
  }
}

module "law" {
  source     = "../../"
  depends_on = [module.rgs]
  laws = {
    law1 = {
      location      = module.rgs.groups.laws.location
      resourcegroup = module.rgs.groups.laws.name
      sku           = "PerGB2018"
      retention     = 30
      solutions     = ["ContainerInsights", "VMInsights", "AzureActivity"]
    }
  }
}