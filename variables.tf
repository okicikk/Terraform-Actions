variable "resource_group_name" {
  description = "The name of the resource group where the Azure resources will be created."
  type        = string
}
variable "resource_group_location" {
  description = "The Azure region where the resource group will be located."
  type        = string
}
variable "service_plan_name" {
  description = "The name of the Azure App Service Plan."
  type        = string
}
variable "web_app_name" {
  description = "The name of the Azure Linux Web App."
  type        = string
}
variable "sql_server_name" {
  description = "The name of the Azure SQL Server."
  type        = string
}
variable "sql_database_name" {
  description = "The name of the Azure SQL Database."
  type        = string
}
variable "sql_admin_login" {
  description = "The administrator login for the Azure SQL Server."
  type        = string
}
variable "sql_admin_password" {
  description = "The administrator password for the Azure SQL Server."
  type        = string
}
variable "firewall_rule_name" {
  description = "The name of the firewall rule for the Azure SQL Server."
  type        = string
}
variable "github_repo_url" {
  description = "The URL of the GitHub repository for deployment."
  type        = string
}