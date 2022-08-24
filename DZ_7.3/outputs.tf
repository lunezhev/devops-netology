output "internal_ip_address_count" {
  value = (yandex_compute_instance.vm-1-count).*.network_interface.0.ip_address
}

output "external_ip_address_count" {
  value = (yandex_compute_instance.vm-1-count).*.network_interface.0.nat_ip_address
}

output "internal_ip_address_for-each" {
  value = values(yandex_compute_instance.vm-1-fe).*.network_interface.0.ip_address
}

output "external_ip_address_for-each" {
  value = values(yandex_compute_instance.vm-1-fe).*.network_interface.0.nat_ip_address
}