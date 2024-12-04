terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.12.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "StorageFafli" 
    storage_account_name = "accountforstoragee"                     
    container_name       = "containercashee"                      
    key                  = "gluposti.tfstate"       
  }


}
resource "azurerm_resource_group" "manchevrg" {
  name     = "${var.resource_group_name}${random_integer.random_integer_nm.result}"
  location = var.resource_group_location
}

provider "azurerm" {
  subscription_id = "440a5f6d-84d7-47f0-811f-5c293a52c268"
  features {}
}
resource "random_integer" "random_integer_nm" {
  min = 10000
  max = 99999
}

resource "azurerm_service_plan" "contact_book_sp" {
  name                = "${var.app_service_plan_name}-${random_integer.random_integer_nm.result}"
  resource_group_name = azurerm_resource_group.manchevrg.name
  location            = azurerm_resource_group.manchevrg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "linux_web_app_nm" {
  name                = "${var.app_service_name}-${random_integer.random_integer_nm.result}"
  resource_group_name = azurerm_resource_group.manchevrg.name
  location            = azurerm_service_plan.contact_book_sp.location
  service_plan_id     = azurerm_service_plan.contact_book_sp.id

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.server_nm.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sqldatabase_nm.name};User ID=missadministrator;Password=AdminPassword123!;Trusted_Connection=False; MultipleActiveResultSets=True;"

  }

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
}

resource "azurerm_app_service_source_control" "git_hub_nm" {
  app_id                 = azurerm_linux_web_app.linux_web_app_nm.id
  repo_url               = var.git_hub_repo_url
  branch                 = "master"
  use_manual_integration = true
}

resource "azurerm_mssql_server" "server_nm" {
  name                         = "${var.sql_server_name}${random_integer.random_integer_nm.result}"
  resource_group_name          = azurerm_resource_group.manchevrg.name
  location                     = azurerm_resource_group.manchevrg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "sqldatabase_nm" {
  name           = "${var.sql_database_name}${random_integer.random_integer_nm.result}"
  server_id      = azurerm_mssql_server.server_nm.id
  collation      = "SQL_Latin1_General_CP1_CI_AS" # Collation
  license_type   = "LicenseIncluded"              # Options: "LicenseIncluded" or "BasePrice"
  sku_name       = "Basic"                        # Example: Standard S1 tier
  zone_redundant = false                          # Enable Zone Redundancy
}
resource "azurerm_mssql_firewall_rule" "firewall_rule_nm" {
  name             = "${var.firewall_rule_name}${random_integer.random_integer_nm.result}"
  server_id        = azurerm_mssql_server.server_nm.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
