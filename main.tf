#----------------------------------------------------------------------------------------
# resourcegroups
#----------------------------------------------------------------------------------------

data "azurerm_resource_group" "rg" {
  for_each = var.laws

  name = each.value.resourcegroup
}

#----------------------------------------------------------------------------------------
# generate random id
#----------------------------------------------------------------------------------------

resource "random_string" "random" {
  length    = 3
  min_lower = 3
  special   = false
  numeric   = false
  upper     = false
}

#----------------------------------------------------------------------------------------
# workspaces
#----------------------------------------------------------------------------------------

resource "azurerm_log_analytics_workspace" "law" {
  for_each = var.laws

  name                = "log-${var.naming.company}-${each.key}-${var.naming.env}-${var.naming.region}-${random_string.random.result}"
  resource_group_name = data.azurerm_resource_group.rg[each.key].name
  location            = data.azurerm_resource_group.rg[each.key].location
  sku                 = each.value.sku

  daily_quota_gb                     = try(each.value.daily_quota_gb, null)
  internet_ingestion_enabled         = try(each.value.internet_ingestion_enabled, null)
  internet_query_enabled             = try(each.value.internet_query_enabled, null)
  retention_in_days                  = try(each.value.retention, 30)
  reservation_capacity_in_gb_per_day = try(each.value.reservation_capacity_in_gb_per_day, null)

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
