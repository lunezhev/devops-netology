variable "tf-sa" {
  type    = string
  default = "ajekvaavu3gq4ntoqehb"
}

variable "cloud_id" {
  type    = string
  default = "b1gfsdnkd5no371fk503"
}

variable "folder_id" {
  type    = string
  default = "b1g63r6cv324nqcitmbp"
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "bucket_name" {
  type    = string
  default = "lunezhev"
}

variable "a_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "b_zone" {
  type    = string
  default = "ru-central1-b"
}

variable "d_zone" {
  type    = string
  default = "ru-central1-d"
}

variable "vpc_name" {
  type    = string
  default = "net"
}

variable "vm_resources" {
  type = map(any)
  default = {
    default = {
      "cores"         = 2
      "memory"        = 2
      "core_fraction" = 20
    }
    master = {
      "cores"         = 2
      "memory"        = 2
      "core_fraction" = 20
    }
    worker = {
      "cores"         = 2
      "memory"        = 2
      "core_fraction" = 20
    }
  }
}