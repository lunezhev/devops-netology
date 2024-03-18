# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

}

provider "yandex" {
  token = "y0_AgAEA7qj_cdbAATuwQAAAAD6wYFyAABfdPFCJclL3pi0RYlkWi6yZ8L1LQ"
  cloud_id = "var.yandex_cloud_id"
  folder_id = "var.yandex_folder_id"
  zone  = var.a-zone
}

terraform {
  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "lunezhev"
    region = "ru-central1"
    key    = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

  }
}
