variable "resource_group_name" {
  type        = string
  description = "Resource group name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "Resource group location in Azure"
}

variable "app_service_plan_name" {
  type        = string
  description = "App service plan name in Azure"
}

variable "app_service_name" {
  type        = string
  description = "App service name in Azure"
}

variable "sql_server_name" {
  type        = string
  description = "Sql server name in Azure"
}

variable "sql_database_name" {
  type        = string
  description = "Sql database name in Azure"
}

variable "sql_admin_username" {
  type        = string
  description = "SQL admin username for login in Azure"
}

variable "sql_admin_password" {
  type        = string
  description = "SQL admin password for login in Azure"
}

variable "firewall_rule_name" {
  type        = string
  description = "Firewall rule name in Azure"
}

variable "git_hub_repo_url" {
  type        = string
  description = "GitHub repo URL in Azure"
}
