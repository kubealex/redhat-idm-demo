provider "libvirt" {
  uri = "qemu:///system"
}

# module "libvirt_resources" {
#   source = "./libvirt-resources"
#   network_domain          = var.network_domain
#   network_cidr            = var.network_cidr    
#   network_dnsmasq_options = var.network_dnsmasq_options
# }

module "idm_instances" {
  source  = "./idm"
  # depends_on = [ module.libvirt_resources ]
  idm_instance_cloud_image = var.idm_instance_cloud_image
  idm_instance_domain = var.network_domain
}

module "idm_clients" {
  source  = "./idm-clients"
  # depends_on = [ module.libvirt_resources ]
  rhel9_instance_cloud_image = var.rhel9_instance_cloud_image  
  client_instance_domain = var.network_domain
}

terraform {
 required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}
