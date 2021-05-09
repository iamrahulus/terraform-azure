provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rsg-fnapp" {
  name     = "azure-functions-blob-python"
  location = "Central US"
}

resource "azurerm_storage_account" "storageacc-fnapp" {
  name                     = "fnappsblobstorage"
  resource_group_name      = azurerm_resource_group.rsg-fnapp.name
  location                 = azurerm_resource_group.rsg-fnapp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_storage_container" "container-fnapp" {
  name                  = "samples-workitems"
  storage_account_name  = azurerm_storage_account.storageacc-fnapp.name
  container_access_type = "private"
}

resource "azurerm_app_service_plan" "plan-fnapp" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.rsg-fnapp.location
  resource_group_name = azurerm_resource_group.rsg-fnapp.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "example" {
  name                       = "terraform-azure"
  location                   = azurerm_resource_group.rsg-fnapp.location
  resource_group_name        = azurerm_resource_group.rsg-fnapp.name
  app_service_plan_id        = azurerm_app_service_plan.plan-fnapp.id
  storage_account_name       = azurerm_storage_account.storageacc-fnapp.name
  storage_account_access_key = azurerm_storage_account.storageacc-fnapp.primary_access_key
  os_type                    = "linux"
}