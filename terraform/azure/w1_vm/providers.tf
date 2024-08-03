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
  #subscription_id = "8b337f83-ac4b-4562-a3c6-e3ea6d2ca635"
  #tenant_id = "548cb08f-5f98-4dd1-a0b0-ff92090fbbc2"
  features {}
}