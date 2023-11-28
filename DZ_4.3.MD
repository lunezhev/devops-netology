### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-03-yaml/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import time
import datetime
import json
import yaml

i = 1
srv = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}

fpath="./"

print('*** start script ***')
print(srv)
print('********************')



while 1 == 1 :
    for host in srv:
        ip = socket.gethostbyname(host)
        if ip != srv[host]:
            with open(fpath+host+".json",'w') as jsf:
                json_data=json.dumps({host:ip})
                jsf.write(json_data)
            with open(fpath+host+".yaml",'w') as ymf:
                yaml_data= yaml.dump([{host : ip}])
                ymf.write(yaml_data)
            print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) +' [ERROR] ' + str(host) +' IP mistmatch: '+srv[host]+' '+ip)
            srv[host]=ip
        else:
            print(host, ': ', srv[host])


#счетчик итераций для отладки, закомментировать для бесконечного цикла 3 строки
    i+=1 
    if i >= 10 : 
        break
    time.sleep(2)
```

### Вывод скрипта при запуске при тестировании:
```
ad@k8s:~$ python3 test.py
*** start script ***
{'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}
********************
2022-02-28 09:51:16 [ERROR] drive.google.com IP mistmatch: 0.0.0.0 173.194.222.194
2022-02-28 09:51:16 [ERROR] mail.google.com IP mistmatch: 0.0.0.0 142.251.1.18
2022-02-28 09:51:16 [ERROR] google.com IP mistmatch: 0.0.0.0 173.194.222.101
drive.google.com :  173.194.222.194
mail.google.com :  142.251.1.18
2022-02-28 09:51:18 [ERROR] google.com IP mistmatch: 173.194.222.101 64.233.163.101
drive.google.com :  173.194.222.194
mail.google.com :  142.251.1.18
google.com :  64.233.163.101
2022-02-28 09:51:22 [ERROR] drive.google.com IP mistmatch: 173.194.222.194 74.125.131.194
mail.google.com :  142.251.1.18
google.com :  64.233.163.101
drive.google.com :  74.125.131.194
mail.google.com :  142.251.1.18
google.com :  64.233.163.101
drive.google.com :  74.125.131.194
mail.google.com :  142.251.1.18
google.com :  64.233.163.101
drive.google.com :  74.125.131.194
mail.google.com :  142.251.1.18
google.com :  64.233.163.101
drive.google.com :  74.125.131.194
mail.google.com :  142.251.1.18
google.com :  64.233.163.101
drive.google.com :  74.125.131.194
mail.google.com :  142.251.1.18
google.com :  64.233.163.101
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
ad@k8s:~$ ls
drive.google.com.yaml  google.com.yaml       mail.google.com.yaml  test.py
drive.google.com.json  google.com.json        mail.google.com.json  my_env
ad@k8s:~$ cat drive.google.com.json
{"drive.google.com": "74.125.131.194"}
ad@k8s:~$ cat google.com.json
{"google.com": "64.233.163.101"}
ad@k8s:~$ cat mail.google.com.json
{"mail.google.com": "142.251.1.18"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
ad@k8s:~$ ls
drive.google.com.yaml  google.com.yaml       mail.google.com.yaml  test.py
drive.google.com.json  google.com.json        mail.google.com.json  my_env
ad@k8s:~$ cat drive.google.com.yaml
- drive.google.com: 74.125.131.194
ad@k8s:~$ cat google.com.yaml
- google.com: 64.233.163.101
ad@k8s:~$ cat mail.google.com.yaml
- mail.google.com: 142.251.1.18
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python

```

### Пример работы скрипта:
???