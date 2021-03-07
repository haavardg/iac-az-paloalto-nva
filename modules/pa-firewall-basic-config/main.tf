provider "panos" {
    hostname = "${var.panvm_mgmt_ip}" 
    username = "${var.panvm_username}"
    password = "${var.panvm_password}"
}

resource "panos_ethernet_interface" "eth1" {
    name = "ethernet1/1"
    vsys = "vsys1"
    mode = "layer3"
    enable_dhcp = true
    create_dhcp_default_route = true
}

resource "panos_ethernet_interface" "eth2" {
    name = "ethernet1/2"
    vsys = "vsys1"
    mode = "layer3"
    enable_dhcp = true
}



resource "panos_zone" "int" {
    name = "L3-trust"
    mode = "layer3"
    interfaces = ["${panos_ethernet_interface.eth1.name}"]
}

resource "panos_zone" "ext" {
    name = "L3-untrust"
    mode = "layer3"
    interfaces = ["${panos_ethernet_interface.eth2.name}"]
}

resource "panos_virtual_router" "vr_public" {
    name = "vr-public"
    interfaces = [
        "${panos_ethernet_interface.eth1.name}"
    ]
}

resource "panos_virtual_router" "vr_private" {
    name = "vr-private"
    interfaces = [
        "${panos_ethernet_interface.eth2.name}"
    ]
}

resource "panos_static_route_ipv4" "vr_public_default" {
    name = "default"
    virtual_router = panos_virtual_router.vr_public.name
    interface = "ethernet1/1"
    destination = "0.0.0.0/0"
    next_hop = "${var.panvm_defaultroute}"
}

resource "panos_static_route_ipv4" "vr_private_default" {
    name = "default"
    virtual_router = panos_virtual_router.vr_private.name
    type = "next-vr"
    destination = "0.0.0.0/0"
    next_hop = panos_virtual_router.vr_public.name
}