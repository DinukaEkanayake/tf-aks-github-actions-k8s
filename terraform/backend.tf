terraform {
  backend "azurerm" {
    resource_group_name = "platform-test-backend-resource-group" #Azure Resource Group where the storage account is located
    storage_account_name = "platformtestbackend" #Azure Storage Account that will store the Terraform state file
    container_name = "tfstate" #Azure Blob Storage Container inside the Storage Account.This container holds the Terraform state file
    key = "akstest.terraform.tfstate" #key acts as the file path within the container.
  }
}