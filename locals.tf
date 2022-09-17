locals {
  workspace_solutions = flatten([
    for law_key, law in var.laws : [
      for solution_key, solution in try(law.solutions, {}) : {

        law_key        = law_key
        solution_key   = solution_key
        publisher      = solution.publisher
        solution_name  = solution.name
        product        = solution.product
        promotion_code = try(solution.promotion_code, "")
        location       = law.location
        workspace_id   = azurerm_log_analytics_workspace.law[law_key].id
        workspace_name = azurerm_log_analytics_workspace.law[law_key].name
        resourcegroup  = azurerm_resource_group.rg[law_key].name
      }
    ]
  ])
}