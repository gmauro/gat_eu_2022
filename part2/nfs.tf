resource "openstack_compute_instance_v2" "nfs" {
  name            = "nfs-server"
  image_name      = "vggp-v40-j255-a33bb037f9fb-master"
  flavor_name     = "c1.denbi_cloud_user_meeting"
  key_pair        = openstack_compute_keypair_v2.my-cloud-key.name
  security_groups = ["default"]
  network {
    name = "public"
  }
  user_data = <<-EOF
  #cloud-config
  write_files:
  - content: |
      /data/share *(rw,sync)
    owner: root:root
    path: /etc/exports
    permissions: '0644'
  runcmd:
   - [ mkdir, -p, /data/share ]
   - [ chown, "centos:centos", -R, /data/share ]
   - [ systemctl, enable, nfs-server ]
   - [ systemctl, start, nfs-server ]
   - [ exportfs, -avr ]
EOF
}