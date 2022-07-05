resource "random_id" "unique_name_suffix" {
  byte_length = 8
}

resource "openstack_compute_keypair_v2" "my-cloud-key" {
  name       = "tf_workshop_key_${random_id.unique_name_suffix.hex}"
  public_key = "ssh-rsa AAAAB3Nza..."
}

