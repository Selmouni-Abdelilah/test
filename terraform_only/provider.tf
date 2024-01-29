terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}
provider "azurerm" {
 alias      = "source"
 subscription_id = "1dabcf09-861c-4374-aebf-d63be509564b"
 features {} 
}
provider "azurerm" {
 alias      = "dest"
 subscription_id = "07cfeda7-60f3-4f0e-8844-42f3057ba5bb"
 features {} 
}