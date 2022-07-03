output "node_name" {
  value = openstack_compute_instance_v2.head.name
}

output "ip_v4_public" {
  value = openstack_compute_instance_v2.head.access_ip_v4
}