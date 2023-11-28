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


## НЕ ПОЛНОСТЬЮ ГОТОВО! НЕ ПРОВЕРЯТЬ))) Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

```
1. Не хватает трех ковычек в 9 строке, после IP и вокруг 71.78.22.43

{ "info" : "Sample JSON output from our service\t",
    "elements" :[
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        },
        { "name" : "second",
        "type" : "proxy",
        "ip" : "71.78.22.43"
        }
    ]
}

2. 
##!/usr/bin/env python3

import socket
import time
import datetime
import json
import yaml

i = 1
srv = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}

#fpath = "C:\\Users\\Andrew\\AppData\\Local\\Programs\\Python\\Python39\\"
fpath="./"

print('*** start script ***')
print(srv)
print('********************')



while 1 == 1 :
    print(i)
    for host in srv:
        ip = socket.gethostbyname(host)
        if ip != srv[host]:
            with open(fpath+host+".json",'w') as jsf:
                json_data=json.dumps({host:ip})
                jsf.write(json_data)
            print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) +' [ERROR] ' + str(host) +' IP mistmatch: '+srv[host]+' '+ip)
            srv[host]=ip
        else:
            print(host, ': ', srv[host])
            with open(fpath+host+".json",'w') as jsf:
               json_data=json.dumps({host:ip})
               jsf.write(json_data)

#счетчик итераций для отладки, закомментировать для бесконечного цикла 3 строки
    i+=1 
    if i >= 5 : 
        break
    time.sleep(2)
```