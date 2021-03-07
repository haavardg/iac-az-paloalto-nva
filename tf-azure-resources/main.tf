provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=2.4.0"
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}

module "firewall" {
  source = "../modules/az-palo-alto-lab"
  location = "West Europe"
  nameprefix = "pa-h"
  tenant_id = var.tenant_id
}