resource "random_string" "kv_fw" {
  length  = 4
  upper   = false
  number  = false
  lower   = true
  special = false
}

resource "azurerm_key_vault" "kv_fw" {
  name                        = "${var.nameprefix}-kv-fw-${random_string.kv_fw.result}"
  location                    = azurerm_resource_group.rg_panvm.location
  resource_group_name         = azurerm_resource_group.rg_panvm.name
  tenant_id                   = var.tenant_id
  purge_protection_enabled    = false
  sku_name = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
      "create",
      "update",
      "delete"
    ]

    secret_permissions = [
      "get",
      "set",
      "list",
      "delete"
    ]

    storage_permissions = [
      "get",
      "set",
      "update",
      "delete"
    ]

    certificate_permissions = [
      "get",
      "create",
      "update",
      "delete"
    ]

  }
}

resource "random_password" "admin_pwd_pavm" {
  length           = 16
  special          = true
  override_special = "_%@"
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "admin-password-hub-dc" {
  name         = "admin-pwd-${var.nameprefix}-vm-fw"
  value        = random_password.admin_pwd_pavm.result
  key_vault_id = azurerm_key_vault.kv_fw.id

}