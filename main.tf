#----------------------------------------------------------------------------------------
# resourcegroups
#----------------------------------------------------------------------------------------

resource "azurerm_resource_group" "rg" {
  for_each = var.laws

  name     = each.value.resourcegroup
  location = each.value.location
}

#----------------------------------------------------------------------------------------
# generate random id
#----------------------------------------------------------------------------------------

resource "random_string" "random" {
  length    = 5
  min_lower = 5
  special   = false
  numeric   = false
  upper     = false
}

#----------------------------------------------------------------------------------------
# workspaces
#----------------------------------------------------------------------------------------

resource "azurerm_log_analytics_workspace" "law" {
  for_each = var.laws

  name                       = "law${var.env}${random_string.random.result}"
  location                   = each.value.location
  resource_group_name        = azurerm_resource_group.rg[each.key].name
  daily_quota_gb             = try(each.value.daily_quota_gb, null)
  internet_ingestion_enabled = try(each.value.internet_ingestion_enabled, null)
  internet_query_enabled     = try(each.value.internet_query_enabled, null)
  sku                        = each.value.sku
  retention_in_days          = each.value.retention
}

#----------------------------------------------------------------------------------------
# solutions
#----------------------------------------------------------------------------------------

resource "azurerm_log_analytics_solution" "solution" {
  for_each = {
    for solution in local.workspace_solutions : "${solution.law_key}.${solution.solution_key}" => solution
  }

  solution_name         = each.value.solution_name
  location              = each.value.location
  resource_group_name   = each.value.resourcegroup
  workspace_resource_id = each.value.workspace_id
  workspace_name        = each.value.workspace_name

  plan {
    publisher = each.value.publisher
    product   = each.value.product
  }
}