# Log Analytic Workspaces

This terraform module simplifies the creation of log analytics resources on the azure cloud platform, allowing users to collect and analyze data from a variety of sources. With this module, users can easily provision a centralized, scalable, and secure log analytics solution with minimal effort.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Features

- offers support for multiple solutions, facilitating seamless integration of various monitoring and analytics capabilities
- utilization of terratest for robust validation.

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
module "logging" {
  source = "github.com/aztfmods/terraform-azure-law?ref=v1.6.0"

  workload    = var.workload
  environment = var.environment

  law = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    sku           = "PerGB2018"
    retention     = 90
  }
  depends_on = [module.rg]
}
```

## Usage: solutions

```hcl
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
```

## Resources

| Name | Type |
| :-- | :-- |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_log_analytics_solution](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_solution) | resource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `law` | describes log analytics related configuration | object | yes |
| `workload` | contains the workload name used, for naming convention	| string | yes |
| `environment` | contains shortname of the environment used for naming convention	| string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `law` | contains all log analytics workspaces |

## Testing

The github repository utilizes a Makefile to conduct tests to evaluate and validate different configurations of the module. These tests are designed to enhance its stability and reliability.

Before initiating the tests, please ensure that both go and terraform are properly installed on your system.

The [Makefile](Makefile) incorporates three distinct test variations. The first one, a local deployment test, is designed for local deployments and allows the overriding of workload and environment values. It includes additional checks and can be initiated using the command ```make test_local```.

The second variation is an extended test. This test performs additional validations and serves as the default test for the module within the github workflow.

The third variation allows for specific deployment tests. By providing a unique test name in the github workflow, it overrides the default extended test, executing the specific deployment test instead.

Each of these tests contributes to the robustness and resilience of the module. They ensure the module performs consistently and accurately under different scenarios and configurations.

## Authors

Module is maintained by [Dennis Kool](https://github.com/dkooll).

## License

MIT Licensed. See [LICENSE](https://github.com/aztfmods/terraform-azure-law/blob/main/LICENSE) for full details.

## Reference

- [Log Analytics Workspace Documentation - Microsoft docs](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview)
- [Log Analytics Workspace Rest Api - Microsoft docs](https://learn.microsoft.com/en-us/rest/api/loganalytics/)
