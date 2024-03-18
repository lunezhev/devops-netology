resource "yandex_iam_service_account" "sa" {
  name = "sa"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.yandex_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Создание бакета с использованием ключа
#resource "yandex_storage_bucket" "test" {
#  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
#  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
#  bucket     = "lunezhev"
#}

resource "yandex_compute_instance" "nat-instance" {
  name     = var.nat-instance-name
  hostname = "${var.nat-instance-name}.${var.domain}"
  zone     = var.a-zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.nat-instance-image-id
      name     = "root-${var.nat-instance-name}"
      type     = "network-nvme"
      size     = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet-public.id
    ip_address = var.nat-instance-ip
    nat        = true
  }

  metadata = {
    user-data = "${file("./and.yaml")}"
  }
}

resource "yandex_compute_instance" "public-vm" {
  name     = var.public-vm-name
  hostname = "${var.public-vm-name}.${var.domain}"
  zone     = var.a-zone

  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = var.ubuntu-20-04-lts
      name     = "root-${var.public-vm-name}"
      type     = "network-nvme"
      size     = "10"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-public.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./and.yaml")}"
  }
}

resource "yandex_compute_instance" "private-vm" {
  name     = var.private-vm-name
  hostname = "${var.private-vm-name}.${var.domain}"
  zone     = var.a-zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu-20-04-lts
      name     = "root-${var.private-vm-name}"
      type     = "network-nvme"
      size     = "10"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-private.id
    nat       = false
  }

  metadata = {
    user-data = "${file("./and.yaml")}"
  }
}
