provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=2.4.0"
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}

data "azurerm_key_vault" "pavm_kv" {
  name                = var.kv_name
  resource_group_name = var.kv_rg_name
}

// get admin login password for palo alto mgmt
data "azurerm_key_vault_secret" "pavm_password" {
  name         = var.kv_secret_name
  key_vault_id = data.azurerm_key_vault.pavm_kv.id
}

//  get public ip of mgmt interface for palo alto firewall
data "azurerm_public_ip" "pavm_pip_mgmt" {
  name                = var.pip_name
  resource_group_name = var.pip_rg_name
}

module "firewall" {
  source = "../modules/pa-firewall-basic-config"
  panvm_password = data.azurerm_key_vault_secret.pavm_password.value
  panvm_mgmt_ip = data.azurerm_public_ip.pavm_pip_mgmt.ip_address
}