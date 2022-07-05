resource "openstack_compute_instance_v2" "head" {
  name            = "central-manager"
  image_id        = data.openstack_images_image_v2.tf_workshop-image.id
  flavor_name     = var.flavors.central-manager
  key_pair        = openstack_compute_keypair_v2.my-cloud-key.name
  security_groups = var.secgroups_cm
  network {
    uuid = data.openstack_networking_network_v2.external.id
  }
  network {
    uuid = data.openstack_networking_network_v2.internal.id
  }

  user_data = <<-EOF
  #cloud-config
  write_files:
  - content: |
      CONDOR_HOST = localhost
      ALLOW_WRITE = *
      ALLOW_READ = $(ALLOW_WRITE)
      ALLOW_NEGOTIATOR = $(ALLOW_WRITE)
      DAEMON_LIST = COLLECTOR, MASTER, NEGOTIATOR, SCHEDD
      FILESYSTEM_DOMAIN = tf_workshop_${random_id.unique_name_suffix.hex}
      UID_DOMAIN = tf_workshop_${random_id.unique_name_suffix.hex}
      TRUST_UID_DOMAIN = True
      SOFT_UID_DOMAIN = True
    owner: root:root
    path: /etc/condor/condor_config.local
    permissions: '0644'
  - content: |
      /data           /etc/auto.data          nfsvers=3
    owner: root:root
    path: /etc/auto.master.d/data.autofs
    permissions: '0644'
  - content: |
      share  -rw,hard,intr,nosuid,quota  ${openstack_compute_instance_v2.nfs.access_ip_v4}:/data/share
    owner: root:root
    path: /etc/auto.data
    permissions: '0644'
EOF
}