resource "azurerm_storage_account" "storage" {
  name                     = "aksblobstorage${random_string.suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_container" "blob_container" {
  name                  = "nginx-data"
  storage_account_id = azurerm_storage_account.storage.id
  container_access_type = "private"
}
