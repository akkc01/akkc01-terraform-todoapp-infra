terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstatefile_rg_for_all_do_not_delete"
    storage_account_name = "tfstatergb17g2devops"
    container_name       = "tfstatefilecontainer"
    key                  = "prodtodo.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "c0748677-9808-4356-8816-dc8088c5bb59"
}
