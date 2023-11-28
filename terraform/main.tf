provider "yandex" {
  cloud_id  = "b1gfsdnkd5no371fk503"
  folder_id = "b1g63r6cv324nqcitmbp"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "test" {
  name = "test"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ju9iqf6g5bcq77jns"
	  name        = "root-test"
      type        = "network-nvme"
      size        = "20"
    }
  }

    network_interface {
    subnet_id = yandex_vpc_subnet.test_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "test_network" {
  name = "test_network"
}

resource "yandex_vpc_subnet" "test_subnet" {
  name           = "test_subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.test_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
