terraform {
  required_version = ">=1.9.0" #Ensures that Terraform version 1.9.0 or later is used
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" #download the azurerm provider from HashiCorp’s official registry.
      version = "~>4.0" #Use any version starting from 3.0.0 up to (but not including) 4.0.0
    }
  }
}

provider "azurerm" {
  features { #placeholder for any optional settings like enabling specific Azure services or behaviors in Terraform
  }
  subscription_id = "2360694b-1c31-40eb-9ff9-b1ede7406ff8"
}
