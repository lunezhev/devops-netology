# devops-netology
## Домашнее задание к занятию "3.5. Файловые системы"
```


1. Изучил. Хорошее решение для хранения больших файлов, таких как бэкапы, образы виртуальных машин, торрентов


2. Владелец и права будут одни и те же, т.к. хардлинк - ссылка на тот же самый файл и индексный дескриптор тот же самый.

vagrant@vagrant:~$ touch test_file
vagrant@vagrant:~$ ln test_file test_link
vagrant@vagrant:~$ ls -ilh
total 40K
131081 -rw-r--r-- 1 vagrant vagrant 40K Dec  5 12:22 '-l root'
131091 -rw-rw-r-- 2 vagrant vagrant   0 Feb 14 13:47  test_file
131091 -rw-rw-r-- 2 vagrant vagrant   0 Feb 14 13:47  test_link
vagrant@vagrant:~$ chmod 0755 test_file
vagrant@vagrant:~$ ls -ilh
total 40K
131081 -rw-r--r-- 1 vagrant vagrant 40K Dec  5 12:22 '-l root'
131091 -rwxr-xr-x 2 vagrant vagrant   0 Feb 14 13:47  test_file
131091 -rwxr-xr-x 2 vagrant vagrant   0 Feb 14 13:47  test_link

3. Создал
vagrant@vagrant:~$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
sdc                    8:32   0  2.5G  0 disk
sr0                   11:0    1 58.3M  0 rom

4. 
vagrant@vagrant:~$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x999d023e

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux

5. 
root@vagrant:~# sfdisk -d /dev/sdb|sfdisk --force /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x999d023e.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x999d023e

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

6. 
root@vagrant:~# mdadm --create --verbose /dev/md1 -l 1 -n 2 /dev/sd{b1,c1}
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.

7. 
root@vagrant:~# mdadm --create --verbose /dev/md2 -l 1 -n 2 /dev/sd{b2,c2}
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 522240K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md2 started.

8. 
root@vagrant:~# pvcreate /dev/md1 /dev/md2
  Physical volume "/dev/md1" successfully created.
  Physical volume "/dev/md2" successfully created.

9. 
root@vagrant:~# vgcreate vg1 /dev/md1 /dev/md2
  Volume group "vg1" successfully created

10. 
root@vagrant:~# lvcreate -L 100M vg1 /dev/md2
  Logical volume "lvol0" created.
root@vagrant:~# lvs
  LV     VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvol0  vg1       -wi-a----- 100.00m
  root   vgvagrant -wi-ao---- <62.54g
  swap_1 vgvagrant -wi-ao---- 980.00m

11. 
root@vagrant:~# mkfs.ext4 /dev/vg1/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

12. 
root@vagrant:~# mkdir /tmp/new
root@vagrant:~# mount /dev/vg1/lvol0 /tmp/new

13. 
root@vagrant:~# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-02-14 14:39:18--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22316792 (21M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz              100%[=================================================>]  21.28M  1.32MB/s    in 12s

2022-02-14 14:39:31 (1.72 MB/s) - ‘/tmp/new/test.gz’ saved [22316792/22316792]

root@vagrant:~# ls /tmp/new
lost+found  test.gz

14. 
root@vagrant:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md1                9:1    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
  └─md2                9:2    0  510M  0 raid1
    └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md1                9:1    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
  └─md2                9:2    0  510M  0 raid1
    └─vg1-lvol0      253:2    0  100M  0 lvm   /tmp/new
sr0                   11:0    1 58.3M  0 rom

15. 
root@vagrant:~# gzip -t /tmp/new/test.gz && echo $?
0

16. 
root@vagrant:~# pvmove /dev/md2
  /dev/md2: Moved: 12.00%
  /dev/md2: Moved: 100.00%

17. 
root@vagrant:~# mdadm /dev/md1 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md1

root@vagrant:~# mdadm -D /dev/md1
/dev/md1:
           Version : 1.2
     Creation Time : Mon Feb 14 14:22:28 2022
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Mon Feb 14 14:44:38 2022
             State : clean, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:1  (local to host vagrant)
              UUID : b324da8a:0df9c0b4:8b3f106a:3fefbf61
            Events : 19

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1

       0       8       17        -      faulty   /dev/sdb1

18. 
root@vagrant:~# dmesg |grep md1
[ 1489.221321] md/raid1:md1: not clean -- starting background reconstruction
[ 1489.221322] md/raid1:md1: active with 2 out of 2 mirrors
[ 1489.221333] md1: detected capacity change from 0 to 2144337920
[ 1489.221716] md: resync of RAID array md1
[ 1499.503749] md: md1: resync done.
[ 2817.462503] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.

19. 
root@vagrant:~# gzip -t /tmp/new/test.gz && echo $?
0

20.
vagrant@vagrant:~$ exit
logout
Connection to 127.0.0.1 closed.
PS D:\vagrant> vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] ==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...

```
