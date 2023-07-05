provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/aztfmods/terraform-azure-rg"

  environment = var.environment

  groups = {
    demo = {
      region = "westeurope"
    }
  }
}

module "law" {
  source = "github.com/aztfmods/terraform-azure-law?ref=v1.6.0"

  workload    = var.workload
  environment = var.environment

  law = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    sku           = "PerGB2018"
    retention     = 90
    solutions     = ["ContainerInsights", "VMInsights", "AzureActivity"]
  }
  depends_on = [module.rg]
}
