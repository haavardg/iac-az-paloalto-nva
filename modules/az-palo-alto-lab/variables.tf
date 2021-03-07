// global variables
variable "location" {}
variable "nameprefix" {}
variable "tenant_id" {}

// network variables
variable "address_space_vnet_connection_hub" {
    default = ["10.10.0.0/24"]
}
variable "address_space_subnet_fw_mgmt" {
    default = "10.10.0.0/27"
}
variable "address_space_subnet_fw_untrusted" {
    default = "10.10.0.32/27"
}
variable "address_space_subnet_fw_trusted" {
    default = "10.10.0.64/27"
}
variable "address_space_subnet_agw_web1" {
    default = "10.10.0.96/27"
}

// Palo Alto vm variables
variable "panvm_username" {
  default = "fw-operator"
}

variable "panvm_os_disk_size" {
    default = 64
}
variable "panvm_nic_trusted_ipaddress" {
    default = "10.10.0.70"
}
variable "panvm_size" {
    default = "Standard_DS3_v2"
}
variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
  default     = "paloaltonetworks"
}
variable "image_offer" {
  description = "The name of the offer (az vm image list)"
  default     = "vmseries1"
}
variable "image_sku" {
  description = "Image SKU to apply (az vm image list)"
  default     = "byol"
}
variable "image_version" {
  description = "Version of the image to apply"
  default     = "9.1.0"
}

// Palo Alto PanOS variables
