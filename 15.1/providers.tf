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
  cloud_id  = var.yandex_cloud_id
  folder_id = var.yandex_folder_id
  zone  = var.a-zone
}
