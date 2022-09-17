locals {
  workspace_solutions = flatten([
    for law_key, law in var.laws : [
      for solution_key, solution in try(law.solutions, {}) : {

        law_key        = law_key
        solution_key   = solution_key
        publisher      = "Microsoft"
        solution_name  = solution
        product        = "OMSGallery/${solution}"
        location       = law.location
        workspace_id   = azurerm_log_analytics_workspace.law[law_key].id
        workspace_name = azurerm_log_analytics_workspace.law[law_key].name
        resourcegroup  = azurerm_resource_group.rg[law_key].name
      }
    ]
  ])
}