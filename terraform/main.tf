resource "azurerm_resource_group" "az_rg" {
  name     = var.name
  location = var.location

  tags = {
    Region      = var.location
    Environment = var.env
  }
}