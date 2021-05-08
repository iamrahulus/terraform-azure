resource "azurerm_resource_group" "rsg-fnapp" {
  name     = "azure-functions-blob-python"
  location = "Central US"
}

resource "azurerm_storage_account" "storageacc-fnapp" {
  name                     = "fn-apps-blob-storage"
  resource_group_name      = azurerm_resource_group.rsg-fnapp.name
  location                 = azurerm_resource_group.rsg-fnapp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "plan-fnapp" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.rsg-fnapp.location
  resource_group_name = azurerm_resource_group.rsg-fnapp.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "example" {
  name                       = "test-azure-functions"
  location                   = azurerm_resource_group.rsg-fnapp.location
  resource_group_name        = azurerm_resource_group.rsg-fnapp.name
  app_service_plan_id        = azurerm_app_service_plan.plan-fnapp.id
  storage_account_name       = azurerm_storage_account.storageacc-fnapp.name
  storage_account_access_key = azurerm_storage_account.storageacc-fnapp.primary_access_key
}