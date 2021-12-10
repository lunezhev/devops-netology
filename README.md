# devops-netology
## Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"
```
1.  Встроенная.
    type cd
    cd is a shell builtin

2. ad@ad:~$ cat testfile
qwertyuiop[]
1234567890
zxcvbnm,./
ghrhdfhdgjrw
asdfghjkl;
qethjtjhtqjrywj
ad@ad:~$ grep qwerty testfile -c
1

3. systemd(1)
ad@ad:~$ pstree -p
systemd(1)─┬─accounts-daemon(668)─┬─{accounts-daemon}(698)
           │                      └─{accounts-daemon}(724)
           ├─agetty(704)
           ├─atd(696)
           ├─containerd(697)─┬─{containerd}(736)
           │                 ├─{containerd}(737)
           │                 ├─{containerd}(738)
           │                 ├─{containerd}(739)
           │                 ├─{containerd}(740)
           │                 ├─{containerd}(754)
           │                 ├─{containerd}(755)
           │                 ├─{containerd}(756)
           │                 ├─{containerd}(757)
           │                 ├─{containerd}(759)
           │                 └─{containerd}(1258)

4. ad@docker:~$ ls -l \root 2>/dev/tty3

```

![](image1.png)

```

5. ad@ad:~$ cat testfile
qwertyuiop[]
1234567890
zxcvbnm,./
ghrhdfhdgjrw
asdfghjkl;
qethjtjhtqjrywj
ad@ad:~$ cat testfile1
cat: testfile1: No such file or directory
ad@ad:~$ cat <testfile >testfile1
ad@ad:~$ cat testfile1
qwertyuiop[]
1234567890
zxcvbnm,./
ghrhdfhdgjrw
asdfghjkl;
qethjtjhtqjrywj



6. ad@docker:~$ tty
/dev/pts/4
ad@docker:~$ echo pts4 >/dev/tty3

```

![](image.png)

```

7. ad@ad:~$ bash 5>&1 Создаст дескриптор 5 и перенаправит его в stdout
ad@ad:~$ echo netology > /proc/$$/fd/5 выведет netology в дескриптор 5

8. ad@ad:~$ ls -l /root 3>&1 1>&2 2>&3 |grep denied -c
1

9. Выводит переменные окружения. Аналоги env, printenv

10. /proc/[pid]/cmdline
              This read-only file holds the complete command line for the process, unless the process is a zombie.
Этот файл содержит полную командную строку запуска процесса, кроме тез, что превратились в зомби (176 строка)

/proc/[pid]/exe
              Under Linux 2.2 and later, this file is a symbolic link containing the actual pathname of the executed command.
Это символьной ссылка, содержащая фактическое полное имя выполняемого файла.

11. grep sse /proc/cpuinfo
SSE 4.2

12. ad@ad:~$ ssh localhost 'tty'
ad@localhost's password: 
not a tty
Интерактивная оболочка не позволяет внутри себя запустить другую интерактивную оболочку, поэтому нежно запустить в псевдо-интерактивном режиме
ad@ad:~$ ssh -t localhost 'tty'
ad@localhost's password: 
/dev/pts/5
Connection to localhost closed.

13. НЕ ПЕРЕХВАТЫВАЕТ(((

ad@ad:/home$ ps -a
    PID TTY          TIME CMD
   5604 pts/5    00:00:00 ping
   5645 pts/6    00:00:00 ps
ad@ad:/home$ reptyr 5604
Unable to attach to pid 5604: Operation not permitted
The kernel denied permission while attaching. If your uid matches
the target's, check the value of /proc/sys/kernel/yama/ptrace_scope.
For more information, see /etc/sysctl.d/10-ptrace.conf
ad@ad:/home$ sudo reptyr 5604
[-] Unable to open the tty in the child.
Unable to attach to pid 5604: Permission denied
ad@ad:/home$ sudo reptyr -T 5604
Unable to attach to pid 5604: Permission denied
ad@ad:/home$ cat /etc/sysctl.d/10-ptrace.conf
# The PTRACE system is used for debugging.  With it, a single user process
# can attach to any other dumpable process owned by the same user.  In the
# case of malicious software, it is possible to use PTRACE to access
# credentials that exist in memory (re-using existing SSH connections,
# extracting GPG agent information, etc).
#
# A PTRACE scope of "0" is the more permissive mode.  A scope of "1" limits
# PTRACE only to direct child processes (e.g. "gdb name-of-program" and
# "strace -f name-of-program" work, but gdb's "attach" and "strace -fp $PID"
# do not).  The PTRACE scope is ignored when a user has CAP_SYS_PTRACE, so
# "sudo strace -fp $PID" will work as before.  For more details see:
# https://wiki.ubuntu.com/SecurityTeam/Roadmap/KernelHardening#ptrace
#
# For applications launching crash handlers that need PTRACE, exceptions can
# be registered by the debugee by declaring in the segfault handler
# specifically which process will be using PTRACE on the debugee:
#   prctl(PR_SET_PTRACER, debugger_pid, 0, 0, 0);
#
# In general, PTRACE is not needed for the average running Ubuntu system.
# To that end, the default is to set the PTRACE scope to "1".  This value
# may not be appropriate for developers or servers with only admin accounts.
kernel.yama.ptrace_scope = 1

Правлю /etc/sysctl.d/10-ptrace.conf kernel.yama.ptrace_scope = 1 на 0
Перезагрузка

ad@ad:/home$ ps -a
    PID TTY          TIME CMD
   3344 pts/8    00:00:00 ping
   3379 pts/4    00:00:00 ps
ad@ad:/home$ reptyr 3344
Unable to attach to pid 3344: Operation not permitted
ad@ad:/home$ sudo reptyr 3344
[sudo] password for ad: 
[-] Unable to open the tty in the child.
Unable to attach to pid 3344: Permission denied
ad@ad:/home$ sudo reptyr -T 3344
Unable to attach to pid 3344: Permission denied
ad@ad:/home$ cat /etc/sysctl.d/10-ptrace.conf
# The PTRACE system is used for debugging.  With it, a single user process
# can attach to any other dumpable process owned by the same user.  In the
# case of malicious software, it is possible to use PTRACE to access
# credentials that exist in memory (re-using existing SSH connections,
# extracting GPG agent information, etc).
#
# A PTRACE scope of "0" is the more permissive mode.  A scope of "1" limits
# PTRACE only to direct child processes (e.g. "gdb name-of-program" and
# "strace -f name-of-program" work, but gdb's "attach" and "strace -fp $PID"
# do not).  The PTRACE scope is ignored when a user has CAP_SYS_PTRACE, so
# "sudo strace -fp $PID" will work as before.  For more details see:
# https://wiki.ubuntu.com/SecurityTeam/Roadmap/KernelHardening#ptrace
#
# For applications launching crash handlers that need PTRACE, exceptions can
# be registered by the debugee by declaring in the segfault handler
# specifically which process will be using PTRACE on the debugee:
#   prctl(PR_SET_PTRACER, debugger_pid, 0, 0, 0);
#
# In general, PTRACE is not needed for the average running Ubuntu system.
# To that end, the default is to set the PTRACE scope to "1".  This value
# may not be appropriate for developers or servers with only admin accounts.
kernel.yama.ptrace_scope = 0

14. tee делает вывод одновременно и в файл в параметре и в stdout. 
В примере команда получает вывод из stdin, перенаправленный через pipe от stdout команды echo, а так как команда запущена от sudo , соотвественно имеет права на запись в файл.

```
