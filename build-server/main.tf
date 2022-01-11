provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "LocalDatacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "Datastore 2"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "UbuntuServer20.04-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

#data "vsphere_resource_pool" "pool" {
#  name          = "10.0.0.202/Resources"
#  datacenter_id = data.vsphere_datacenter.dc.id
#}

data "vsphere_resource_pool" "pool" {
  name          = "resource_pool_test"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "HomeNOC"
  datacenter_id = data.vsphere_datacenter.dc.id
}

variable "name" {
  default = "EvilIWeiShigeruSamurai"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "${var.name}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 4
  memory   = 4096
  guest_id = "ubuntu64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 20
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.name}"
        domain    = "${var.name}.hashy0917.cf"
      }
      network_interface {
        #ipv4_address = "10.0.0.10"
        #ipv4_netmask = 24
      }
      #ipv4_gateway = "10.0.0.1"
    }
  }
}
