provider "azurerm" {
  features {}
}

module "region" {
  source = "github.com/aztfmods/module-azurerm-regions"

  workload    = var.workload
  environment = var.environment

  location = "westeurope"
}

module "rg" {
  source = "github.com/aztfmods/module-azurerm-rg"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short
  location       = module.region.location
}

module "law" {
  source = "../../"

  workload       = var.workload
  environment    = var.environment
  location_short = module.region.location_short

  law = {
    location      = module.rg.group.location
    resourcegroup = module.rg.group.name
    sku           = "PerGB2018"
    retention     = 90
    solutions     = ["ContainerInsights", "VMInsights", "AzureActivity"]
  }
  depends_on = [module.rg]
}
