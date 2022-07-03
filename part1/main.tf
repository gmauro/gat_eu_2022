resource "random_id" "unique_name_suffix" {
  byte_length = 8
}

resource "openstack_compute_keypair_v2" "my-cloud-key" {
  name       = "tf_workshop_key_${random_id.unique_name_suffix.hex}"
  public_key = "ssh-rsa AAAAB3NzaC1..."
}

resource "openstack_compute_instance_v2" "head" {
  name            = "test-vm"
  image_name      = "vggp-v40-j255-a33bb037f9fb-master"
  flavor_name     = "c1.galaxy_eu_c2m8d12"
  key_pair        = openstack_compute_keypair_v2.my-cloud-key.name
  security_groups = ["default"]
  network {
    name = "public"
  }
}
