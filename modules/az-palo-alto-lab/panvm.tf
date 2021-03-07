locals {
  vm_name = "${var.nameprefix}-vm-fw"
}

resource "azurerm_resource_group" "rg_panvm" {
  name     = "${var.nameprefix}-rg-fw"
  location = var.location
}

resource "azurerm_public_ip" "panvm_mgmt_pip" {
  name                = "${local.vm_name}-mgmt-pip"
  location            = azurerm_resource_group.rg_panvm.location
  resource_group_name = azurerm_resource_group.rg_panvm.name
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "panvm_untrusted_pip1" {
  name                = "${local.vm_name}-untrusted-pip"
  location            = azurerm_resource_group.rg_panvm.location
  resource_group_name = azurerm_resource_group.rg_panvm.name
  allocation_method   = "Static"
}

# Create network mgmt
resource "azurerm_network_interface" "panvm_nic_mgmt" {
  name                = "${local.vm_name}-nic-mgmt"
  resource_group_name = azurerm_resource_group.rg_panvm.name
  location            = azurerm_resource_group.rg_panvm.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.fw_mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.panvm_mgmt_pip.id
  }
  enable_ip_forwarding = true
  enable_accelerated_networking = true
}

# Create network untrusted
resource "azurerm_network_interface" "panvm_nic_untrusted" {
  name                = "${local.vm_name}-nic-untrusted"
  resource_group_name = azurerm_resource_group.rg_panvm.name
  location            = azurerm_resource_group.rg_panvm.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.fw_untrusted.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.panvm_untrusted_pip1.id
  }
  enable_ip_forwarding = true
  enable_accelerated_networking = true
}

# Create network trusted
resource "azurerm_network_interface" "panvm_nic_trusted" {
  name                = "${local.vm_name}-nic-trusted"
  resource_group_name = azurerm_resource_group.rg_panvm.name
  location            = azurerm_resource_group.rg_panvm.location

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.fw_trusted.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.panvm_nic_trusted_ipaddress
  }
  enable_ip_forwarding = true
  enable_accelerated_networking = true
}

# Create virtual machine 
resource "azurerm_linux_virtual_machine" "vm" {
  name                          = local.vm_name
  resource_group_name           = azurerm_resource_group.rg_panvm.name
  location                      = azurerm_resource_group.rg_panvm.location
  size                          = var.panvm_size
  
  disable_password_authentication = false
  admin_username = var.panvm_username
  admin_password = random_password.admin_pwd_pavm.result

  network_interface_ids = [
    azurerm_network_interface.panvm_nic_mgmt.id,
    azurerm_network_interface.panvm_nic_untrusted.id,
    azurerm_network_interface.panvm_nic_trusted.id,
  ]

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_disk {
    name          = "${local.vm_name}-osdisk"
    caching       = "ReadWrite"
    disk_size_gb  = var.panvm_os_disk_size
    storage_account_type = "Standard_LRS"
  }

  plan {
    name = "byol"
    publisher = "paloaltonetworks"
    product = "vmseries1"
  }
}
