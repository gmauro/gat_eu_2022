data "openstack_images_image_v2" "tf_workshop-image" {
  name = var.image["name"]
}
