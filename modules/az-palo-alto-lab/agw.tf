



#&nbsp;since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${var.nameprefix}-agw-befw"
  frontend_port_name             = "${var.nameprefix}-agw-feport"
  frontend_ip_configuration_name = "${var.nameprefix}-agw-feip"
  http_setting_name              = "${var.nameprefix}-agw-be-htst"
  listener_name                  = "${var.nameprefix}-agw-httplstn"
  request_routing_rule_name      = "${var.nameprefix}-agw-rqrt"
  redirect_configuration_name    = "${var.nameprefix}-agw-rdrcfg"
}

resource "azurerm_resource_group" "rg_agw" {
  name     = "${var.nameprefix}-rg-agw"
  location = var.location
}

resource "azurerm_user_assigned_identity" "agw_fe_user" {
  location            = azurerm_resource_group.rg_agw.location
  resource_group_name = azurerm_resource_group.rg_agw.name

  name = "${var.nameprefix}-agw-fe-user"
}

resource "azurerm_public_ip" "agw_fe_pip" {
  name                = "${var.nameprefix}-agw-fe-pip"
  location            = azurerm_resource_group.rg_agw.location
  resource_group_name = azurerm_resource_group.rg_agw.name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_application_gateway" "network" {
  name                = "${var.nameprefix}-agw"
  location            = azurerm_resource_group.rg_agw.location
  resource_group_name = azurerm_resource_group.rg_agw.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  identity {
    identity_ids = [ azurerm_user_assigned_identity.agw_fe_user.id ]
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = azurerm_subnet.agw_web1.id
  }

  frontend_port {
    name = "fe-http"
    port = 80
  }

  frontend_port {
    name = "fe-https"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.agw_fe_pip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
    ip_addresses = [ var.panvm_nic_trusted_ipaddress ]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = "fe-http"
    protocol                       = "Http"
    host_name                      = "agw.grondal.me"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}