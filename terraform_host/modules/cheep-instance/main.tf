variable instance_name { default = "" }
variable family { default = "centos-7" }
variable subnet_id { default = "" }

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

data "yandex_compute_image" "default" {
  family = var.family
}

resource "yandex_compute_instance" "instance" {

  name                      = "${var.instance_name}"
  description               = "Дешевая и слабая нода"
  zone                      = "ru-central1-a"
  hostname                  = "${var.instance_name}"
  allow_stopping_for_update = true

  platform_id = "standard-v3"

  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.default.id
      size = "10"
    }
  }

  network_interface {
    subnet_id  = "${var.subnet_id}"
    nat        = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "external-ip" {
  value = "${yandex_compute_instance.instance.network_interface.0.nat_ip_address}" 
}


