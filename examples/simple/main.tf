module "law" {
  source = "../../"
  laws = {
    law1 = {
      location      = "westeurope"
      resourcegroup = "rg-law-weeu"
      sku           = "PerGB2018"
      retention     = 30
      solutions     = ["ContainerInsights", "VMInsights", "AzureActivity"]
    }
  }
}