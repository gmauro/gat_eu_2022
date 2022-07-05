output "node_name" {
  value = openstack_compute_instance_v2.head.name
}

output "ip_v4_public" {
  value = openstack_compute_instance_v2.head.network.0.fixed_ip_v4
}

output "ip_v4_private" {
  value = openstack_compute_instance_v2.head.network.1.fixed_ip_v4
}
