# generate random id
resource "random_string" "random" {
  length    = 3
  min_lower = 3
  special   = false
  numeric   = false
  upper     = false
}

# workspaces
resource "azurerm_log_analytics_workspace" "law" {
  name                = "log-${var.workload}-${var.environment}-${random_string.random.result}"
  resource_group_name = var.law.resourcegroup
  location            = var.law.location
  sku                 = var.law.sku

  daily_quota_gb                     = try(var.law.daily_quota_gb, null)
  internet_ingestion_enabled         = try(var.law.internet_ingestion_enabled, true)
  internet_query_enabled             = try(var.law.internet_query_enabled, true)
  retention_in_days                  = try(var.law.retention, 30)
  reservation_capacity_in_gb_per_day = try(var.law.reservation_capacity_in_gb_per_day, null)
  allow_resource_only_permissions    = try(var.law.allow_resource_only_permissions, true)
}

# solutions
resource "azurerm_log_analytics_solution" "solutions" {
  for_each = {
    for solution in local.solutions : solution.solution_key => solution
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
