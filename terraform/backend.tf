terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-lab"
    storage_account_name = "terrafromstatefile235"
    container_name       = "uks-terraform-tfstate"
  }
}

provider "azurerm" {
  features {}
}