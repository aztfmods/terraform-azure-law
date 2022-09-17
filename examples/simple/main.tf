module "law" {
  source = "../../"
  laws = {
    law1 = {
      location      = "westeurope"
      resourcegroup = "rg-network-weeu"
      sku           = "PerGB2018"
      retention     = 30
      solutions = {
        sol1 = { name = "ContainerInsights", publisher = "Microsoft", product = "OMSGallery/ContainerInsights" }
      }
    }
  }
}