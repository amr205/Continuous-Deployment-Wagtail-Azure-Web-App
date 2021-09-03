terraform {
  backend "remote" {
    organization = "amr205"

    workspaces {
      name = "AzureWagtail"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "azureWagtail" {
  name     = "azureWagtailResourceGroup"
  location = "westus"
}

resource "azurerm_app_service_plan" "azureWagtail" {
  name                = "slotAppServicePlan"
  location            = azurerm_resource_group.azureWagtail.location
  resource_group_name = azurerm_resource_group.azureWagtail.name
  kind = "Linux"
  reserved=true
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "azureWagtail" {
  name                = "doaAzWebAppAlex"
  location            = azurerm_resource_group.azureWagtail.location
  resource_group_name = azurerm_resource_group.azureWagtail.name
  app_service_plan_id = azurerm_app_service_plan.azureWagtail.id

  site_config {
    linux_fx_version = "PYTHON|3.6"
    python_version = "3.4"
  }
}

resource "azurerm_app_service_slot" "azureWagtail" {
  name                = "slotOne"
  location            = azurerm_resource_group.azureWagtail.location
  resource_group_name = azurerm_resource_group.azureWagtail.name
  app_service_plan_id = azurerm_app_service_plan.azureWagtail.id
  app_service_name    = azurerm_app_service.azureWagtail.name

  site_config {
    linux_fx_version = "PYTHON|3.6"
    python_version = "3.4"
  }
}