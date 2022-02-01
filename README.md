# devops-netology
## Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"
```
1.  chdir("/tmp") - системный вызов, который относится именно к cd.

2. База данных file находится по пути "/usr/share/misc/magic.mgc" (строка: "openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3")

3. Первый терминал:
ad@ad:~$ vi 123
   Редактируется, сохраняется.
   Второй терминал:
root@ad:/home/ad# pgrep vi
364947
root@ad:/home/ad# lsof -p 364947 | grep 123
vi      364947   ad    4u   REG  253,0    12288  786990 /home/ad/.123.swp
root@ad:/home/ad# rm -f /home/ad/.123.swp
root@ad:/home/ad# lsof -p 364947 | grep 123
vi      364947   ad    4u   REG  253,0    12288  786990 /home/ad/.123.swp (deleted)
root@ad:/home/ad# echo '' >/proc/364947/fd/4
root@ad:/home/ad# lsof -p 364947 | grep 123
vi      364947   ad    4u   REG  253,0        1  786990 /home/ad/.123.swp (deleted)
   В первом терминале файл редактируется в редакторе, сохраняется.
   Второй терминал:
root@ad:/home/ad# lsof -p 364947 | grep 123
vi      364947   ad    4u   REG  253,0        1  786990 /home/ad/.123.swp (deleted)

4. Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов. 

5. root@ad:/home/ad# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
root@ad:/home/ad# /usr/sbin/opensnoop-bpfcc -d 1
PID    COMM               FD ERR PATH
2459   redis-server       13   0 /proc/290/stat
332176 node               19   0 /proc/341997/cmdline
2459   redis-server       13   0 /proc/290/stat
342002 sh                  3   0 /etc/ld.so.cache
342002 sh                  3   0 /lib/x86_64-linux-gnu/libc.so.6
342003 which               3   0 /etc/ld.so.cache
342003 which               3   0 /lib/x86_64-linux-gnu/libc.so.6
342003 which               3   0 /usr/bin/which
342004 sh                  3   0 /etc/ld.so.cache
342004 sh                  3   0 /lib/x86_64-linux-gnu/libc.so.6
342005 ps                  3   0 /etc/ld.so.cache

6. Используется системный вызов "uname()".
   Part of the utsname information is also accessible via proc/sys/kernel/{ostype, hostname, osrelease, version domainname}.

7. ; - разделитель команд, а && -  условный оператор. Соответственно, в "test -d /tmp/some_dir && echo Hi" echo сработает только в случае успешного завершения test.
   Смысла использовать в bash && с set -e, на мой взгляд нет, т.к. set -e прерывает работу сценария при появлении первой же ошибки (когда команда возвращает ненулевой код завершения), соответственно, при ошибке выполнение команд прекратится.

8. Параметры:
-e - Прерывает работу сценария при появлении первой же ошибки (когда команда возвращает ненулевой код завершения).
-x - Выводит команды со всеми развернутыми подстановками и вычислениями.
-u - При попытке обращения к неопределенным переменным, выдает сообщение об ошибке и прерывает работу сценария.
-o pipefile - прекращает выполнение скрипта, даже если хоть одна из частей пайпа завершилась ошибкой. В этом случае bash-скрипт завершит выполнение, даже не смотря на true в конце пайплайна.
  Незаменим при отладке и логгировании, считается хорошим тоном при написании bash-скриптом.

9. У себя встретил только S - процесс ожидает (т.е. спит менее 20 секунд) и I - процесс бездействует (т.е. спит больше 20 секунд), без параметров или с оными, указывающими на приоритет и прочие характеристики.

```
