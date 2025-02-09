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
  subscription_id = "f56740bd-c42d-45b3-947f-be53d2eef564"
}
