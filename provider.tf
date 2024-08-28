terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74.0" # Assurez-vous que cette version correspond à celle que vous avez choisie
    }
  }
}

provider "azurerm" {
  features {}
}
