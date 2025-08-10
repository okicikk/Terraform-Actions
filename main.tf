terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.38.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "StorageRG"
    storage_account_name = "taskboardstorageokicikk"
    container_name       = "taskboardcontainer-okicikk"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
  subscription_id = "ac7da106-7101-4d6f-ba0e-afbb66841f1c"
}
resource "random_integer" "ri" {
  min = 1
  max = 50000
}
resource "azurerm_resource_group" "azurewebapprg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}
resource "azurerm_service_plan" "azurewebapp_plan" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  os_type             = "Linux"
  sku_name            = "F1"
  depends_on = [
    azurerm_resource_group.azurewebapprg
  ]

}
resource "azurerm_app_service_source_control" "github_deployment" {
  app_id                 = azurerm_linux_web_app.azurewebapp.id
  repo_url               = var.github_repo_url
  branch                 = "main"
  use_manual_integration = true # Set to true to use manual integration
}
resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  depends_on = [
    azurerm_resource_group.azurewebapprg
  ]
}

resource "azurerm_mssql_database" "sqldb" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.sqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "Basic"
  zone_redundant = false
}
resource "azurerm_mssql_firewall_rule" "azureaccess" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
resource "azurerm_linux_web_app" "azurewebapp" {
  name                = var.web_app_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  service_plan_id     = azurerm_service_plan.azurewebapp_plan.id

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${var.sql_database_name};User ID=${var.sql_admin_login};Password=${var.sql_admin_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}
