terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.100.0"
    }
  }
}

provider "azurerm" {

  subscription_id = "your subscription id"
  client_id       = ""
  tenant_id       = ""
  client_secret   = ""
  features {

  }

}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_queue" "queue" {
  name                 = var.queue_name
  storage_account_name = azurerm_storage_account.storage.name
}

resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_app_service_plan" "example_sp" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}
resource "azurerm_function_app" "func" {
  name                       = "QueueToBlobFunc"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  storage_account_name       = azurerm_storage_account.storage.name
  app_service_plan_id        = azurerm_app_service_plan.example_sp.id
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key

  os_type = "linux"


  app_settings = {
    AzureWebJobsStorage      = azurerm_storage_account.storage.primary_connection_string
    FUNCTIONS_WORKER_RUNTIME = "dotnet"
    QUEUE_NAME               = var.queue_name
    STORAGE_CONTAINER        = var.container_name
  }
}
