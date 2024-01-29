terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
provider "azurerm" {
 alias      = "dest"
 subscription_id = "07cfeda7-60f3-4f0e-8844-42f3057ba5bb"
 features {} 
}