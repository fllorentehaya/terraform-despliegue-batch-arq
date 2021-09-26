#grupo de recursos
terraform {
  required_providers {
    databricks = {
      source  = "databrickslabs/databricks"
      version = "0.3.0"
    }
  }
}
provider "azurerm" {
  
  features{}
}

data "azurerm_client_config" "current" {}
#Datalake Gen2
resource "azurerm_resource_group" "sdggruporecursos" {
  name     = "${var.prefijo}-rg-${var.entorno}-001"
  location = var.localizacion #"West Europe"
  

}
resource "azurerm_storage_account" "sdgcuentaalmacenamiento" {
  name                     = "${var.prefijo}${var.entorno}storageaccount"
  resource_group_name      = azurerm_resource_group.sdggruporecursos.name
  location                 = azurerm_resource_group.sdggruporecursos.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}
resource "azurerm_storage_container" "principal" {
  name                  = "${var.prefijo}fs"
  storage_account_name  = azurerm_storage_account.sdgcuentaalmacenamiento.name
  container_access_type = "private"
}


#Azure Data Factory v2
resource "azurerm_data_factory" "sdgdatafactory" {
  name                = "${var.prefijo}-df-${var.entorno}-001"
  location            = azurerm_resource_group.sdggruporecursos.location
  resource_group_name = azurerm_resource_group.sdggruporecursos.name
}
#functions app
resource "azurerm_app_service_plan" "sdgserviceplan" {
  name                = "${var.prefijo}-serviceplan${var.entorno}-001"
  location            = azurerm_resource_group.sdggruporecursos.location
  resource_group_name = azurerm_resource_group.sdggruporecursos.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"

  }
  tags = {
    environment = "${var.prefijo}"
  }
}

resource "azurerm_function_app" "sdgfunctionapp" {
  name                       = "${var.prefijo}-af-${var.entorno}-001"
  location                   = azurerm_resource_group.sdggruporecursos.location
  resource_group_name        = azurerm_resource_group.sdggruporecursos.name
  app_service_plan_id        = azurerm_app_service_plan.sdgserviceplan.id
  storage_account_name       = azurerm_storage_account.sdgcuentaalmacenamiento.name
  storage_account_access_key = azurerm_storage_account.sdgcuentaalmacenamiento.primary_access_key
  os_type                    = "linux"
  tags = {
    environment = "${var.prefijo}"
  }
}
#azure service bus
resource "azurerm_servicebus_namespace" "sdgservicebus" {
  name                = "${var.prefijo}-sb-${var.entorno}-001"
  location            = azurerm_resource_group.sdggruporecursos.location
  resource_group_name = azurerm_resource_group.sdggruporecursos.name
  sku                 = "Standard"

  tags = {
    environment = "${var.prefijo}"
  }
}
#databricks2
resource "azurerm_databricks_workspace" "sdgdatabricks" {
  name                = "${var.prefijo}-dbrick-${var.entorno}-001"
  resource_group_name = azurerm_resource_group.sdggruporecursos.name
  location            = azurerm_resource_group.sdggruporecursos.location
  sku                 = "premium"

  tags = {
    environment = "${var.prefijo}"
  }
}
output "databricks_ws_host" {
  value="${azurerm_databricks_workspace.sdgdatabricks.workspace_url}"
}


#sqlDatabase sin base de datos por seguridad
resource "azurerm_sql_server" "sdgsqldatabase" {
  name                         = "${var.prefijo}sqlserver${var.entorno}"
  resource_group_name          = azurerm_resource_group.sdggruporecursos.name
  location                     = "${var.localizacion}"
  version                      = "12.0"
  administrator_login          = "admindb"
  administrator_login_password = "4.weq.4.rqa.12"

 
}

resource "azurerm_sql_database" "sdgdatabase" {
  name                = "myexamplesqldatabase"
  resource_group_name = azurerm_resource_group.sdggruporecursos.name
  location            = "${var.localizacion}"
  server_name         = azurerm_sql_server.sdgsqldatabase.name

}
