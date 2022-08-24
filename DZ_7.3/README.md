# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 


## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
* Вывод команды `terraform plan` для воркспейса `prod`.  


<details>
<summary>terraform init</summary>

```

```

</details>

### Ответ:

[main.tf](https://github.com/lunezhev/devops-netology/blob/main/DZ_7.3/main.tf)

[s3.tf](https://github.com/lunezhev/devops-netology/blob/main/DZ_7.3/s3.tf)

[main.tf](https://github.com/lunezhev/devops-netology/blob/main/DZ_7.3/versions.tf)

[outputs.tf](https://github.com/lunezhev/devops-netology/blob/main/DZ_7.3/outputs.tf)

<details>
<summary>terraform init</summary>

```
root@v1272864:~/devops-netology/DZ_7.3# terraform init -backend-config=backend.conf

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.77.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

</details>


<details>
<summary>terraform workspace list</summary>

```
root@v1272864:~/devops-netology/DZ_7.3# terraform workspace list
  default
* prod
  stage
```

![](7.3_1.png)

</details>

<details>
<summary>terraform plan</summary>

```
root@v1272864:~/devops-netology/DZ_7.3# terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm-1-count[0] will be created
  + resource "yandex_compute_instance" "vm-1-count" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD9UPABZvMBObtq35baOzfoRUreDBq1lFj9OnLPR8LNxHNwE90cp2bHZ5HfDJnsNvpQZZu+baQk6urgscG1ze8FJX/HjdGO2o4EsalAdyaod7tGi0m62kYvqI5ZyJqs12t7lrEoEdPWmxsk/cyFlfFxr+n22zUkGj1TeDBiro2W9s7na6nBfOIoVh7QI8UF8SCK7wiVGLDt/uK7nDHjIw7OxLIu68q42AoWZZJ0UmoPjHwBPedbnQxtVbD1LECiXlfGkiJdLdKLz0TRvrC24gfDq+QSopsyAhiXmo6cd+S0dNNcLCA8eL0Zm+wH6SsLioDvX2kv/+XAh40TjrT+8pLP root@v1272864.hosted-by-vdsina.ru
            EOT
        }
      + name                      = "prod-count-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8ju9iqf6g5bcq77jns"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1-count[1] will be created
  + resource "yandex_compute_instance" "vm-1-count" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD9UPABZvMBObtq35baOzfoRUreDBq1lFj9OnLPR8LNxHNwE90cp2bHZ5HfDJnsNvpQZZu+baQk6urgscG1ze8FJX/HjdGO2o4EsalAdyaod7tGi0m62kYvqI5ZyJqs12t7lrEoEdPWmxsk/cyFlfFxr+n22zUkGj1TeDBiro2W9s7na6nBfOIoVh7QI8UF8SCK7wiVGLDt/uK7nDHjIw7OxLIu68q42AoWZZJ0UmoPjHwBPedbnQxtVbD1LECiXlfGkiJdLdKLz0TRvrC24gfDq+QSopsyAhiXmo6cd+S0dNNcLCA8eL0Zm+wH6SsLioDvX2kv/+XAh40TjrT+8pLP root@v1272864.hosted-by-vdsina.ru
            EOT
        }
      + name                      = "prod-count-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8ju9iqf6g5bcq77jns"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1-fe["2"] will be created
  + resource "yandex_compute_instance" "vm-1-fe" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD9UPABZvMBObtq35baOzfoRUreDBq1lFj9OnLPR8LNxHNwE90cp2bHZ5HfDJnsNvpQZZu+baQk6urgscG1ze8FJX/HjdGO2o4EsalAdyaod7tGi0m62kYvqI5ZyJqs12t7lrEoEdPWmxsk/cyFlfFxr+n22zUkGj1TeDBiro2W9s7na6nBfOIoVh7QI8UF8SCK7wiVGLDt/uK7nDHjIw7OxLIu68q42AoWZZJ0UmoPjHwBPedbnQxtVbD1LECiXlfGkiJdLdKLz0TRvrC24gfDq+QSopsyAhiXmo6cd+S0dNNcLCA8eL0Zm+wH6SsLioDvX2kv/+XAh40TjrT+8pLP root@v1272864.hosted-by-vdsina.ru
            EOT
        }
      + name                      = "prod-foreach-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8ju9iqf6g5bcq77jns"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1-fe["3"] will be created
  + resource "yandex_compute_instance" "vm-1-fe" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD9UPABZvMBObtq35baOzfoRUreDBq1lFj9OnLPR8LNxHNwE90cp2bHZ5HfDJnsNvpQZZu+baQk6urgscG1ze8FJX/HjdGO2o4EsalAdyaod7tGi0m62kYvqI5ZyJqs12t7lrEoEdPWmxsk/cyFlfFxr+n22zUkGj1TeDBiro2W9s7na6nBfOIoVh7QI8UF8SCK7wiVGLDt/uK7nDHjIw7OxLIu68q42AoWZZJ0UmoPjHwBPedbnQxtVbD1LECiXlfGkiJdLdKLz0TRvrC24gfDq+QSopsyAhiXmo6cd+S0dNNcLCA8eL0Zm+wH6SsLioDvX2kv/+XAh40TjrT+8pLP root@v1272864.hosted-by-vdsina.ru
            EOT
        }
      + name                      = "prod-foreach-3"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8ju9iqf6g5bcq77jns"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "172.16.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_count    = [
      + (known after apply),
      + (known after apply),
    ]
  + external_ip_address_for-each = [
      + (known after apply),
      + (known after apply),
    ]
  + internal_ip_address_count    = [
      + (known after apply),
      + (known after apply),
    ]
  + internal_ip_address_for-each = [
      + (known after apply),
      + (known after apply),
    ]

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

</details>

<details>
<summary>terraform apply</summary>

```
root@v1272864:~/devops-netology/DZ_7.3# terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm-1-count[0] will be created
  + resource "yandex_compute_instance" "vm-1-count" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD9UPABZvMBObtq35baOzfoRUreDBq1lFj9OnLPR8LNxHNwE90cp2bHZ5HfDJnsNvpQZZu+baQk6urgscG1ze8FJX/HjdGO2o4EsalAdyaod7tGi0m62kYvqI5ZyJqs12t7lrEoEdPWmxsk/cyFlfFxr+n22zUkGj1TeDBiro2W9s7na6nBfOIoVh7QI8UF8SCK7wiVGLDt/uK7nDHjIw7OxLIu68q42AoWZZJ0UmoPjHwBPedbnQxtVbD1LECiXlfGkiJdLdKLz0TRvrC24gfDq+QSopsyAhiXmo6cd+S0dNNcLCA8eL0Zm+wH6SsLioDvX2kv/+XAh40TjrT+8pLP root@v1272864.hosted-by-vdsina.ru
            EOT
        }
      + name                      = "prod-count-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8ju9iqf6g5bcq77jns"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1-count[1] will be created
  + resource "yandex_compute_instance" "vm-1-count" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD9UPABZvMBObtq35baOzfoRUreDBq1lFj9OnLPR8LNxHNwE90cp2bHZ5HfDJnsNvpQZZu+baQk6urgscG1ze8FJX/HjdGO2o4EsalAdyaod7tGi0m62kYvqI5ZyJqs12t7lrEoEdPWmxsk/cyFlfFxr+n22zUkGj1TeDBiro2W9s7na6nBfOIoVh7QI8UF8SCK7wiVGLDt/uK7nDHjIw7OxLIu68q42AoWZZJ0UmoPjHwBPedbnQxtVbD1LECiXlfGkiJdLdKLz0TRvrC24gfDq+QSopsyAhiXmo6cd+S0dNNcLCA8eL0Zm+wH6SsLioDvX2kv/+XAh40TjrT+8pLP root@v1272864.hosted-by-vdsina.ru
            EOT
        }
      + name                      = "prod-count-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8ju9iqf6g5bcq77jns"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1-fe["2"] will be created
  + resource "yandex_compute_instance" "vm-1-fe" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD9UPABZvMBObtq35baOzfoRUreDBq1lFj9OnLPR8LNxHNwE90cp2bHZ5HfDJnsNvpQZZu+baQk6urgscG1ze8FJX/HjdGO2o4EsalAdyaod7tGi0m62kYvqI5ZyJqs12t7lrEoEdPWmxsk/cyFlfFxr+n22zUkGj1TeDBiro2W9s7na6nBfOIoVh7QI8UF8SCK7wiVGLDt/uK7nDHjIw7OxLIu68q42AoWZZJ0UmoPjHwBPedbnQxtVbD1LECiXlfGkiJdLdKLz0TRvrC24gfDq+QSopsyAhiXmo6cd+S0dNNcLCA8eL0Zm+wH6SsLioDvX2kv/+XAh40TjrT+8pLP root@v1272864.hosted-by-vdsina.ru
            EOT
        }
      + name                      = "prod-foreach-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8ju9iqf6g5bcq77jns"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.vm-1-fe["3"] will be created
  + resource "yandex_compute_instance" "vm-1-fe" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD9UPABZvMBObtq35baOzfoRUreDBq1lFj9OnLPR8LNxHNwE90cp2bHZ5HfDJnsNvpQZZu+baQk6urgscG1ze8FJX/HjdGO2o4EsalAdyaod7tGi0m62kYvqI5ZyJqs12t7lrEoEdPWmxsk/cyFlfFxr+n22zUkGj1TeDBiro2W9s7na6nBfOIoVh7QI8UF8SCK7wiVGLDt/uK7nDHjIw7OxLIu68q42AoWZZJ0UmoPjHwBPedbnQxtVbD1LECiXlfGkiJdLdKLz0TRvrC24gfDq+QSopsyAhiXmo6cd+S0dNNcLCA8eL0Zm+wH6SsLioDvX2kv/+XAh40TjrT+8pLP root@v1272864.hosted-by-vdsina.ru
            EOT
        }
      + name                      = "prod-foreach-3"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8ju9iqf6g5bcq77jns"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet1"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "172.16.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 6 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_count    = [
      + (known after apply),
      + (known after apply),
    ]
  + external_ip_address_for-each = [
      + (known after apply),
      + (known after apply),
    ]
  + internal_ip_address_count    = [
      + (known after apply),
      + (known after apply),
    ]
  + internal_ip_address_for-each = [
      + (known after apply),
      + (known after apply),
    ]
yandex_vpc_network.network-1: Creating...
yandex_vpc_network.network-1: Creation complete after 1s [id=enp7v1595fmq4h0gp38j]
yandex_vpc_subnet.subnet-1: Creating...
yandex_vpc_subnet.subnet-1: Creation complete after 1s [id=e9b9te0bmfdrrp6cilgu]
yandex_compute_instance.vm-1-count[0]: Creating...
yandex_compute_instance.vm-1-count[1]: Creating...
yandex_compute_instance.vm-1-fe["3"]: Creating...
yandex_compute_instance.vm-1-fe["2"]: Creating...
yandex_compute_instance.vm-1-count[0]: Still creating... [10s elapsed]
yandex_compute_instance.vm-1-count[1]: Still creating... [10s elapsed]
yandex_compute_instance.vm-1-fe["3"]: Still creating... [10s elapsed]
yandex_compute_instance.vm-1-fe["2"]: Still creating... [10s elapsed]
yandex_compute_instance.vm-1-count[0]: Still creating... [20s elapsed]
yandex_compute_instance.vm-1-count[1]: Still creating... [20s elapsed]
yandex_compute_instance.vm-1-fe["3"]: Still creating... [20s elapsed]
yandex_compute_instance.vm-1-fe["2"]: Still creating... [20s elapsed]
yandex_compute_instance.vm-1-fe["2"]: Creation complete after 21s [id=fhmhq49q54olie2bu033]
yandex_compute_instance.vm-1-count[1]: Creation complete after 22s [id=fhma7a6hgis5ublphep4]
yandex_compute_instance.vm-1-count[0]: Still creating... [30s elapsed]
yandex_compute_instance.vm-1-fe["3"]: Still creating... [30s elapsed]
yandex_compute_instance.vm-1-count[0]: Still creating... [40s elapsed]
yandex_compute_instance.vm-1-fe["3"]: Still creating... [40s elapsed]
yandex_compute_instance.vm-1-count[0]: Creation complete after 41s [id=fhmni8cdjllhr5c87tj9]
yandex_compute_instance.vm-1-fe["3"]: Creation complete after 43s [id=fhm5b64b64eab4k1560a]

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_count = [
  "84.201.132.241",
  "84.201.132.123",
]
external_ip_address_for-each = [
  "51.250.81.254",
  "84.201.129.104",
]
internal_ip_address_count = [
  "172.16.20.6",
  "172.16.20.10",
]
internal_ip_address_for-each = [
  "172.16.20.24",
  "172.16.20.3",
]
```

![](7.3_2.png)

</details>


---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
