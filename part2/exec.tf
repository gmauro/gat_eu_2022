resource "openstack_compute_instance_v2" "exec" {
  name            = "exec-node-${count.index}"
  image_name      = "vggp-v40-j255-a33bb037f9fb-master"
  flavor_name     = "c1.denbi_cloud_user_meeting"
  key_pair        = openstack_compute_keypair_v2.my-cloud-key.name
  security_groups = ["default"]
  count           = var.exec_node_count
  network {
    name = "public"
  }
  user_data = <<-EOF
  #cloud-config
  write_files:
  - content: |
      CONDOR_HOST = ${openstack_compute_instance_v2.head.access_ip_v4}
      ALLOW_WRITE = *
      ALLOW_READ = $(ALLOW_WRITE)
      ALLOW_ADMINISTRATOR = *
      ALLOW_NEGOTIATOR = $(ALLOW_ADMINISTRATOR)
      ALLOW_CONFIG = $(ALLOW_ADMINISTRATOR)
      ALLOW_DAEMON = $(ALLOW_ADMINISTRATOR)
      ALLOW_OWNER = $(ALLOW_ADMINISTRATOR)
      ALLOW_CLIENT = *
      DAEMON_LIST = MASTER, SCHEDD, STARTD
      FILESYSTEM_DOMAIN = tf_workshop_${random_id.unique_name_suffix.hex}
      UID_DOMAIN = tf_workshop_${random_id.unique_name_suffix.hex}
      TRUST_UID_DOMAIN = True
      SOFT_UID_DOMAIN = True
      # run with partitionable slots
      CLAIM_PARTITIONABLE_LEFTOVERS = True
      NUM_SLOTS = 1
      NUM_SLOTS_TYPE_1 = 1
      SLOT_TYPE_1 = 100%
      SLOT_TYPE_1_PARTITIONABLE = True
      ALLOW_PSLOT_PREEMPTION = False
      STARTD.PROPORTIONAL_SWAP_ASSIGNMENT = True
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