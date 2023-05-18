# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.
<details>
<summary>prod.yml</summary>

```
ad@k8s:~/8.2/playbook$ cat inventory/prod.yml
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_connection: docker
vector:
  hosts:
    vector-01:
      ansible_connection: docker
```
</details>

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.

<details>
<summary>Подготовка</summary>

```
ad@k8s:~/8.2$ docker ps
CONTAINER ID   IMAGE                 COMMAND            CREATED          STATUS          PORTS                                       NAMES
e1939a584acc   pycontribs/centos:7   "sleep 60000000"   33 minutes ago   Up 33 minutes                                               vector-01
5925f913a343   pycontribs/centos:7   "sleep 60000000"   34 minutes ago   Up 34 minutes   0.0.0.0:9000->9000/tcp, :::9000->9000/tcp   clickhouse-01
```
```
ad@k8s:~/8.2/playbook$ cat site.yml
---
- name: Install Vector
  hosts: vector
  tasks:
    - name: Get Vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{
            vector_version }}-x86_64-unknown-linux-gnu.tar.gz"
        dest: "./vector-{{ vector_version }}-x86_64-unknown-linux-gnu.tar.gz"
        mode: 0755
        timeout: 90
        force: true
      tags: download
    - name: Create directory for Vector
      ansible.builtin.file:
        state: directory
        path: "{{ vector_dir }}"
        mode: 0755
      tags: CD
    - name: Extract Vector
      ansible.builtin.unarchive:
        copy: false
        src: "/vector-{{ vector_version }}-x86_64-unknown-linux-gnu.tar.gz"
        dest: "{{ vector_dir }}"
        extra_opts: [--strip-components=2]
        creates: "{{ vector_dir }}/bin/vector"
      tags: extract
    - name: Environment Vector
      ansible.builtin.template:
        src: templates/vector.sh.j2
        dest: /etc/profile.d/vector.sh
        mode: 0755
      tags: env
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - name: Get clickhouse distrib
      block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
            mode: 0755
            timeout: 90
            force: true
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
            mode: 0755
            timeout: 90
            force: true
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0
```
```
ad@k8s:~/8.2/playbook$ cat group_vars/vector/vars.yml
---
vector_version: "0.24.0"
vector_dir: "/etc/vector"
```
```
ad@k8s:~/8.2/playbook$ cat templates/vector.sh.j2
#!/usr/bin/env bash
export VECTOR_DIR={{ vector_dir }}
export PATH=$PATH:$VECTOR_DIR/bin
.vector --config /etc/vector/config/vector.toml
```
</details>

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

<details>
<summary>Lint</summary>

```
ad@k8s:~/8.2$ ansible-lint playbook/site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: playbook/site.yml
WARNING  Listing 3 violation(s) that are fatal
name: All tasks should be named. (name[missing])
playbook/site.yml:11 Task/Handler: block/always/rescue 

jinja: Jinja2 spacing could be improved: create_db.rc != 0 and create_db.rc !=82 -> create_db.rc != 0 and create_db.rc != 82 (jinja[spacing])
playbook/site.yml:36 Jinja2 template rewrite recommendation: `create_db.rc != 0 and create_db.rc != 82`.

yaml: no new line character at the end of file (yaml[new-line-at-end-of-file])
playbook/site.yml:79

You can skip specific rules or tags by adding them to your configuration file:
# .config/ansible-lint.yml
warn_list:  # or 'skip_list' to silence them completely
  - name[missing]  # Rule for checking task and play names.
  - yaml[new-line-at-end-of-file]  # Violations reported by yamllint.

Finished with 2 failure(s), 1 warning(s) on 1 files.
ad@k8s:~/8.2$ sed -i -e '$a\' playbook/site.yml
ad@k8s:~/8.2$ ansible-lint playbook/site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: playbook/site.yml
WARNING  Listing 2 violation(s) that are fatal
name: All tasks should be named. (name[missing])
playbook/site.yml:11 Task/Handler: block/always/rescue 

jinja: Jinja2 spacing could be improved: create_db.rc != 0 and create_db.rc !=82 -> create_db.rc != 0 and create_db.rc != 82 (jinja[spacing])
playbook/site.yml:36 Jinja2 template rewrite recommendation: `create_db.rc != 0 and create_db.rc != 82`.

You can skip specific rules or tags by adding them to your configuration file:
# .config/ansible-lint.yml
warn_list:  # or 'skip_list' to silence them completely
  - name[missing]  # Rule for checking task and play names.

Finished with 1 failure(s), 1 warning(s) on 1 files.

```
Исправил отсутствие имени в 11 строке:
```
  tasks:
    - name: Get clickhouse distrib
      block:
        - name: Get clickhouse distrib
```
```
ad@k8s:~/8.2$ ansible-lint playbook/site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: playbook/site.yml
WARNING  Listing 1 violation(s) that are fatal
jinja: Jinja2 spacing could be improved: create_db.rc != 0 and create_db.rc !=82 -> create_db.rc != 0 and create_db.rc != 82 (jinja[spacing])
playbook/site.yml:37 Jinja2 template rewrite recommendation: `create_db.rc != 0 and create_db.rc != 82`.


Finished with 0 failure(s), 1 warning(s) on 1 files.
```

</details>

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

<details>
<summary>--check</summary>

```
ad@k8s:~/8.2/playbook$ ansible-playbook site.yml -i inventory/prod.yml --check

PLAY [Install Vector] ******************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get Vector distrib] **************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Create directory for Vector] *****************************************************************************************************************************************************************
changed: [vector-01]

TASK [Extract Vector] ******************************************************************************************************************************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: NoneType: None
fatal: [vector-01]: FAILED! => {"changed": false, "msg": "dest '/etc/vector' must be an existing dir"}

PLAY RECAP *****************************************************************************************************************************************************************************************
vector-01                  : ok=3    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```

Вываливается ошибка т.к. с флагом --cheсk не создается папка, которая используется в task.

</details>

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

<details>
<summary>--diff</summary>

```
ad@k8s:~/8.2/playbook$ ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Vector] ******************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get Vector distrib] **************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Create directory for Vector] *****************************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/etc/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01]

TASK [Extract Vector] ******************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Environment Vector] **************************************************************************************************************************************************************************
--- before
+++ after: /home/ad/.ansible/tmp/ansible-local-108851co6d9vnh/tmpr718lyj3/vector.sh.j2
@@ -0,0 +1,4 @@
+#!/usr/bin/env bash
+export VECTOR_DIR=/etc/vector
+export PATH=$PATH:$VECTOR_DIR/bin
+.vector --config /etc/vector/config/vector.toml
\ No newline at end of file

changed: [vector-01]


PLAY RECAP *****************************************************************************************************************************************************************************************
vector-01                  : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

</details>

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

<details>
<summary>--diff</summary>

```
ad@k8s:~/8.2/playbook$ ansible-playbook site.yml -i inventory/prod.yml --diff

PLAY [Install Vector] ******************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get Vector distrib] **************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Create directory for Vector] *****************************************************************************************************************************************************************
ok: [vector-01]

TASK [Extract Vector] ******************************************************************************************************************************************************************************
skipping: [vector-01]

TASK [Environment Vector] **************************************************************************************************************************************************************************
ok: [vector-01]

PLAY RECAP *****************************************************************************************************************************************************************************************  
vector-01                  : ok=4    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
```

</details>

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.


<details>
<summary>Описание</summary>

Плэйбук в первой таске скачивает дистрибутив с версией, указаной в group_vars/vector/vars.yml (тэг download), во второй создает папку по пути из group_vars/vector/vars.yml с нужными правами (тэг CD), в третьей распаковывает (тэг extract), в четвертой запускает с параметрами из шаблона templates/vector.sh.j2 (тэг env)

</details>

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
