### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-01-bash/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

---


# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательная задача 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование |
| ------------- | ------------- | ------------- |
| `c`  | a+b  | Это текст |
| `d`  | 1+2  | Значения переменных получены, но без сложения, т.к. это строка |
| `e`  | 3  | Сложение выполнено |


## Обязательная задача 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```

### Ваш скрипт:
```bash
#!/bin/bash
while (( 1 == 1 ))
  do
    curl https://localhost:4757
    if (($? != 0)) 
      then
        date >> curl.log
      else break
    fi
    sleep 1m
  done
```

## Обязательная задача 3
Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
#!/bin/bash
hosts=(192.168.0.1 173.194.222.113 87.250.250.242)
for i in 1 2 3 4 5
do
  for h in ${hosts[@]}
    do
      OUTPUT="$(curl -I -s --connect-timeout 3 $h:80)";
    	if [ -z "${OUTPUT}" ]
        then echo "IP" $h:80 unavailable >> hosts.log;
        else echo "IP" $h:80 available >> hosts.log;
      fi
      sleep 1;
    done
done
```

## Обязательная задача 4
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
#!/bin/bash
hosts=(192.168.0.1 173.194.222.113 87.250.250.242)
i=0
while [[ $i -lt 1 ]]
do
  for h in ${hosts[@]}
    do
      OUTPUT="$(curl -I -s --connect-timeout 3 $h:80)";
      ((i++));
      echo $i
    	if [ -z "${OUTPUT}" ]
        then 
          echo "IP" $h:80 unavailable >> error.log; 
          break;
        else 
          ((i--));
      fi
      sleep 1;
    done
done
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Мы хотим, чтобы у нас были красивые сообщения для коммитов в репозиторий. Для этого нужно написать локальный хук для git, который будет проверять, что сообщение в коммите содержит код текущего задания в квадратных скобках и количество символов в сообщении не превышает 30. Пример сообщения: \[04-script-01-bash\] сломал хук.

### Ваш скрипт:
```bash
???
```