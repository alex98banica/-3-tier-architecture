terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-three-tier"
  location = var.location
}

module "web_tier" {
  source              = "./arhitecture/web-tier"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

module "app_tier" {
  source              = "./arhitecture/app-tier"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vm_admin_username   = var.vm_admin_username
  vm_admin_password   = var.vm_admin_password
}

module "database_tier" {
  source              = "./arhitecture/database-tier"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  db_admin_username   = var.db_admin_username
  db_admin_password   = var.db_admin_password
}