# devops-netology

Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"

1.  Выполнено

2.  Выполнено

3.  Выполнено

4.  Выполнено

5.  1 gb ram, 2 cpu, 4 mb vboxvga, 64 gb hdd sata, lan intel pro/1000 mt

6.  расскомментировать часть Vagrantfile
    # config.vm.provider "virtualbox" do |vb|
    #   # Display the VirtualBox GUI when booting the machine
    #   vb.gui = true
    #
    #   # Customize the amount of memory on the VM:
    #   vb.memory = "1024"
    # end
    где параметр vb.memory = оперативная память
                 v.cpus = кол-во процессоров

7.  Выполнено

8.  -   export HISTSIZE=   
        man bash -> /HISTSIZE    line 725
    -   ignoreboth сочетает ignorespace и ignoredups, не сохранять строки начинающиеся с символа <пробел> и не сохранять строки, совпадающие с последней выполненной командой

9.  {} - зарезервированные слова, список, в т.ч. список команд. В отличии от "(...)" исполнятся в текущем инстансе. Используется в различных условных циклах, условных операторах или ограничивает тело функции. В командах выполняет подстановку элементов из списка.
    line 179 man bash -> /\{ }
10. touch file{1..100000} создаст файлы от file1 до file100000
    touch file{1..300000} не создаст, слишком дилинный список аргументов (можно создать после изменения максимального размера стека (ulimit -s))

11. Проверяет наличие директории /tmp и возвращает 0 при наличии, 1 при отсутствии.

12. vagrant@vagrant:~$ type -a bash
    bash is /usr/bin/bash
    bash is /bin/bash
    vagrant@vagrant:~$ mkdir /tmp/new_path_dir/
    vagrant@vagrant:~$ cp /bin/bash /tmp/new_path_dir/
    vagrant@vagrant:~$ PATH=/tmp/new_path_dir/:$PATH
    vagrant@vagrant:~$ type -a bash
    bash is /tmp/new_path_dir/bash
    bash is /usr/bin/bash
    bash is /bin/bash

13. at запускает команды в заданное время. batch запускает команды, когда уровни загрузки системы позволяют это делать (когда средняя загрузка системы, читаемая из /proc/loadavg, опускается ниже 0.5, или величины, заданной при вызове atrun.)

14. vagrant suspend