
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
}

resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "default" {
  name = "subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.101.0/24"]
}


module "clickhouse" {
  source = "./modules/cheep-instance"
  instance_name = "clickhouse"
  family = "centos-7"
  subnet_id = "${yandex_vpc_subnet.default.id}"
}

module "vector" {
  source = "./modules/cheep-instance"
  instance_name = "vector"
  family = "centos-7"
  subnet_id = "${yandex_vpc_subnet.default.id}"
}

module "lighthouse" {
  source = "./modules/cheep-instance"
  instance_name = "lighthouse"
  family = "centos-7"
  subnet_id = "${yandex_vpc_subnet.default.id}"
}

output "external_ip_address_clickhouse" {
  value = "${module.clickhouse.external-ip}"
}

output "external_ip_address_vector" {
  value = "${module.vector.external-ip}"
}

output "external_ip_address_lighthouse" {
  value = "${module.lighthouse.external-ip}"
}
