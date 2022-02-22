# devops-netology
## Домашнее задание к занятию «1.1. Введение в DevOps»
```

1.1. Установлено

1.2. Установлено

1.3. Создано

1.4.

bash
```
![bash](bash.jpg)

```
jsonnet
```
![jsonnet](jsonnet.jpg)

```
MD
```
![MD](MD.jpg)

```
terraform
```
![terraform](terraform.jpg)

```
yaml
```
![yaml](yaml.jpg)

```
2. Менеджер проекта формирует и описывает техническое задание (ТЗ) с учетом требования заказчика, требований и спецификаций используемого ПО, возможностей инфраструктуры, а также полностью сопровождает процесс на всех стадиях. Команда разработчиков готовит проект к релизу на тестовый контур. После завершении разработки DevOps выполняет выкладку продукта на тестовый стенд. Тестировщики проверяют проект, оформляют задания на доработку(при необходимости), также могут выполнять дополнительное покрытие тестами продукта. Далее Devops выполняет релиз на предпродакшн, который идентичен продакшн-стенду, (также продукт покрывается тестами). Далее DevOps-ом осуществляется релиз в продакшн. В случае необходимости внесения внерелизных изменений, Devops также участвует в процессе исправления ошибок в связке с командой разработки. Далее продукт передается на сопровождение, DevOps может входить и в команду сопровождения, а также сопровождать продукт.

```
## Домашнее задание к занятию "3.9. Элементы безопасности информационных систем""
```
1. 
```
![](3.9-1.jpg)

```

2. 
```
![](3.9-2.jpg)

```

3. 
ad@k8s:~$ sudo apt install apache2
ad@k8s:~$ sudo a2enmod ssl
Considering dependency setenvif for ssl:
Module setenvif already enabled
Considering dependency mime for ssl:
Module mime already enabled
Considering dependency socache_shmcb for ssl:
Enabling module socache_shmcb.
Enabling module ssl.
See /usr/share/doc/apache2/README.Debian.gz on how to configure SSL and create self-signed certificates.
To activate the new configuration, you need to run:
  systemctl restart apache2
ad@k8s:~$ sudo systemctl restart apache2
ad@k8s:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \-keyout /etc/ssl/private/apache-selfsigned.key \-out /etc/ssl/certs/apache-selfsigned.crt \-subj "/C=RU/ST=Moscow/L=Moscow/O=Company Name/OU=Org/CN=www.172.16.20.209"
Generating a RSA private key
............................+++++
.................................................................................+++++
writing new private key to '/etc/ssl/private/apache-selfsigned.key'
-----
ad@k8s:~$ sudo nano /etc/apache2/sites-available/172.16.20.209.conf
ad@k8s:~$ sudo mkdir /var/www/172.16.20.209
ad@k8s:~$ sudo nano /var/www/172.16.20.209/index.html
ad@k8s:~$ sudo a2ensite 172.16.20.209.conf
Enabling site 172.16.20.209.
To activate the new configuration, you need to run:
  systemctl reload apache2
ad@k8s:~$ sudo apache2ctl configtest
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
Syntax OK
ad@k8s:~$ sudo systemctl reload apache2
```
![](3.9-3.jpg)

```
Для самоподписанных сертификатов это нормально. Браузер предупреждает, что не может проверить подлинность сервера, поскольку сертификат не подписан известным браузеру центром сертификации.

4. Использовал ключ -p для тестирования протоколов 
TLS/SSL (включая SPDY/HTTP2)

ad@docker:~$ docker run --rm -ti  drwetter/testssl.sh -p --parallel --sneaky https://ptspec.ru
 
###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/
 
      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!
 
       Please file bugs @ https://testssl.sh/bugs/
 
###########################################################
 
 Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
 on b773a5aae90c:/home/testssl/bin/openssl.Linux.x86_64
 (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")
 
 Start 2022-02-21 06:00:07        -->> 185.215.4.16:443 (ptspec.ru) <<--
 
 rDNS (185.215.4.16):    --
 Service detected:       HTTP
 
 Testing protocols via sockets except NPN+ALPN 
 
 SSLv2      not offered (OK)
 SSLv3      not offered (OK)
 TLS 1      offered (deprecated)
 TLS 1.1    offered (deprecated)
 TLS 1.2    offered (OK)
 TLS 1.3    offered (OK): final
 NPN/SPDY   not offered
 ALPN/HTTP2 h2, http/1.1 (offered)
 
 Done 2022-02-21 06:00:14 [   9s] -->> 185.215.4.16:443 (ptspec.ru) <<--

5. 
```
![](3.9-5.jpg)

```

6. 
```
![](3.9-6.jpg)

```

7. 
ad@ad:~$ sudo tcpdump -c 100 -w 111.pcap -i ens18
[sudo] password for ad: 
tcpdump: listening on ens18, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
104 packets received by filter
0 packets dropped by kernel

```
![](3.9-7.jpg)

```

```