variable "name" {
  description = "(Required) name of the resource group"
  default = "rg-test-lab"
}

variable "env" {
  description = "(Required) name of the resource group"
  default = "dev"
}

variable "location" {
  description = "(Required) location where this resource has to be created"
  default = "UK South"
}

# Only need when we are running terraform locally
#variable "AZURE_CLIENT_ID" {}
#
#variable "AZURE_CLIENT_SECRET" {}
#
#variable "AZURE_SUBSCRIPTION_ID" {}
#
#variable "AZURE_TENANT_ID" {}

