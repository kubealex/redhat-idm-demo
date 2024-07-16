module "idm_instance" {
  source  = "kubealex/libvirt-resources/libvirt//modules/terraform-libvirt-instance"
  instance_network_interfaces = var.idm_instance_network_interfaces
  instance_libvirt_pool =       var.idm_instance_pool_name
  instance_cloud_image =        var.idm_instance_cloud_image
  instance_hostname =           var.idm_instance_hostname
  instance_domain =             var.idm_instance_domain
  instance_volume_size =        var.idm_instance_volume_size
  instance_memory =             var.idm_instance_memory
  instance_cpu =                var.idm_instance_cpu
  instance_cloud_user =         var.idm_instance_cloud_user
}
