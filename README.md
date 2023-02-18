# Log Analytic Workspaces

This terraform module simplifies the creation of log analytics resources on the azure cloud platform, allowing users to collect and analyze data from a variety of sources. With this module, users can easily provision a centralized, scalable, and secure log analytics solution with minimal effort.

The below features are made available:

- multiple workspaces
- solution support on each workspace
- terratest is used to validate different integrations

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
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
    }
  }
  depends_on = [module.global]
}
```

## Usage: solutions

```hcl
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
```

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_log_analytics_solution](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |

## Data Sources

| Name | Type |
| :-- | :-- |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/1.39.0/docs/data-sources/resource_group) | datasource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `laws` | describes log analytics related configuration | object | yes |
| `company` | contains the company name used, for naming convention	| string | yes |
| `region` | contains the shortname of the region, used for naming convention	| string | yes |
| `env` | contains shortname of the environment used for naming convention	| string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `laws` | contains all log analytics workspaces |

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll) with help from [these awesome contributors](https://github.com/aztfmods/module-azurerm-law/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/aztfmods/module-azurerm-law/blob/main/LICENSE) for full details.
