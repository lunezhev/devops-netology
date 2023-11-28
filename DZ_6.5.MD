# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
```
FROM centos:7
COPY elasticsearch-8.3.3-linux-x86_64.tar.gz  /opt
COPY elasticsearch-8.3.3-linux-x86_64.tar.gz.sha512  /opt
# https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.3.3-linux-x86_64.tar.gz
RUN cd /opt && \
    groupadd elasticsearch && \
    useradd -c "elasticsearch" -g elasticsearch elasticsearch &&\
    yum update -y && yum -y install wget perl-Digest-SHA && \
    shasum -a 512 -c elasticsearch-8.3.3-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.3.3-linux-x86_64.tar.gz && \
	rm elasticsearch-8.3.3-linux-x86_64.tar.gz elasticsearch-8.3.3-linux-x86_64.tar.gz.sha512 && \ 
	mkdir /var/lib/data && chmod -R 777 /var/lib/data && \
    mkdir /var/lib/logs && chmod -R 777 /var/lib/logs && \
	chown -R elasticsearch:elasticsearch /opt/elasticsearch-8.3.3 && \
	yum -y remove wget perl-Digest-SHA && \
	yum clean all
USER elasticsearch
WORKDIR /opt/elasticsearch-8.3.3/
COPY elasticsearch.yml  config/
EXPOSE 9200 9300
ENTRYPOINT ["bin/elasticsearch"]
```
- ссылку на образ в репозитории dockerhub

[ОБРАЗ](https://hub.docker.com/layers/elastic/elf11/elastic/latest/images/sha256-bd9abedc64522d7f5bd11509ad75538e7daf60fc26964b8bb299fc864d344f08?context=repo)
- ответ `elasticsearch` на запрос пути `/` в json виде
```
[elasticsearch@1a682db72adc elasticsearch-8.3.3]$ curl --insecure -u elastic https://localhost:9200
Enter host password for user 'elastic':
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "nykNi_ffT02IOyn20AuS2w",
  "version" : {
    "number" : "8.3.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "801fed82df74dbe537f89b71b098ccaff88d2c56",
    "build_date" : "2022-07-23T19:30:09.227964828Z",
    "build_snapshot" : false,
    "lucene_version" : "9.2.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |
```
[elasticsearch@1a682db72adc elasticsearch-8.3.3]$ curl -X PUT --insecure -u elastic "https://localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 1,  
>       "number_of_replicas": 0 
>     }
>   }
> }
> '
Enter host password for user 'elastic':
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
[elasticsearch@1a682db72adc elasticsearch-8.3.3]$ curl -X PUT --insecure -u elastic "https://localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 2,  
>       "number_of_replicas": 1 
>     }
>   }
> }
> '
Enter host password for user 'elastic':
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}
[elasticsearch@1a682db72adc elasticsearch-8.3.3]$ curl -X PUT --insecure -u elastic "https://localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 4,  
>       "number_of_replicas": 2 
>     }
>   }
> }
> '
Enter host password for user 'elastic':
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}
```

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
```
[elasticsearch@1a682db72adc elasticsearch-8.3.3]$ curl -X GET --insecure -u elastic "https://localhost:9200/_cat/indices?v=true"
Enter host password for user 'elastic':
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
yellow open   ind-3 LljsvbxfRIyz5_ZqlZqVkQ   4   2          0            0       900b           900b
yellow open   ind-2 H9TkWztfQXOnFHN6gJ6Hxw   2   1          0            0       450b           450b
green  open   ind-1 mt5oVgfVQJWZCPw8GgQzYg   1   0          0            0       225b           225b
```

Получите состояние кластера `elasticsearch`, используя API.
```
[elasticsearch@1a682db72adc elasticsearch-8.3.3]$ curl -X GET --insecure -u elastic "https://localhost:9200/_cluster/health?pretty"
Enter host password for user 'elastic':
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 9,
  "active_shards" : 9,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 47.368421052631575
}
```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
```
Статус кластера "yellow" потому, что есть unassigned шарды. Индексы "yellow" те, у кого указано количество реплик, но по факту реплик нет. Все связано с тем, что у нас всего одна нода.
```

Удалите все индексы.
```
[elasticsearch@1a682db72adc elasticsearch-8.3.3]$ curl -X DELETE --insecure -u elastic "https://localhost:9200/ind-1?pretty"
Enter host password for user 'elastic':
{
  "acknowledged" : true
}
[elasticsearch@1a682db72adc elasticsearch-8.3.3]$ curl -X DELETE --insecure -u elastic "https://localhost:9200/ind-2?pretty"
Enter host password for user 'elastic':
{
  "acknowledged" : true
}
[elasticsearch@1a682db72adc elasticsearch-8.3.3]$ curl -X DELETE --insecure -u elastic "https://localhost:9200/ind-3?pretty"
Enter host password for user 'elastic':
{
  "acknowledged" : true
}
[elasticsearch@1a682db72adc elasticsearch-8.3.3]$ curl -X GET --insecure -u elastic "https://localhost:9200/_cat/indices?v=true"
Enter host password for user 'elastic':
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size
```

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

```
зменения в Dockerfile и в elasticsearch.yml
```

```
FROM centos:7
COPY elasticsearch-8.3.3-linux-x86_64.tar.gz  /opt
COPY elasticsearch-8.3.3-linux-x86_64.tar.gz.sha512  /opt
# https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.3.3-linux-x86_64.tar.gz
RUN cd /opt && \
    groupadd elasticsearch && \
    useradd -c "elasticsearch" -g elasticsearch elasticsearch &&\
    yum update -y && yum -y install wget perl-Digest-SHA && \
    shasum -a 512 -c elasticsearch-8.3.3-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.3.3-linux-x86_64.tar.gz && \
	rm elasticsearch-8.3.3-linux-x86_64.tar.gz elasticsearch-8.3.3-linux-x86_64.tar.gz.sha512 && \ 
	mkdir /var/lib/data && chmod -R 777 /var/lib/data && \
    mkdir /var/lib/logs && chmod -R 777 /var/lib/logs && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch-8.3.3 && \
    mkdir /opt/elasticsearch-8.3.3/snapshots && chmod -R 777 /opt/elasticsearch-8.3.3/snapshots && \
	yum -y remove wget perl-Digest-SHA && \
	yum clean all
USER elasticsearch
WORKDIR /opt/elasticsearch-8.3.3/
# RUN mkdir snapshots && chmod -R 777 snapshots
COPY elasticsearch.yml  config/
EXPOSE 9200 9300
ENTRYPOINT ["bin/elasticsearch"]
```

```
node.name: netology_test
path.data: /var/lib/data
path.logs: /var/lib/logs
path.repo: /opt/elasticsearch-8.3.3/snapshots
```
Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.



**Приведите в ответе** запрос API и результат вызова API для создания репозитория.
```
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ curl -X PUT --insecure -u elastic "https://localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
> {
>   "type": "fs",
>   "settings": {
>     "location": "/opt/elasticsearch-8.3.3/snapshots",
>     "compress": true
>   }
> }
> '
Enter host password for user 'elastic':
{
  "acknowledged" : true
}
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
```
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ curl -X PUT --insecure -u elastic "https://localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 1,  
>       "number_of_replicas": 0 
>     }
>   }
> }
> '
Enter host password for user 'elastic':
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ curl -X GET --insecure -u elastic "https://localhost:9200/_cat/indices?v=true"
Enter host password for user 'elastic':
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  poGsqzBrRAaIHPufv3amQw   1   0          0            0       225b           225b
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.
```
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ curl -X PUT --insecure -u elastic "https://localhost:9200/_snapshot/netology_backup/my_1st_snap?pretty"
Enter host password for user 'elastic':
{
  "accepted" : true
}
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ ls snapshots
index-0  index.latest  indices  meta-_uVERtiBQW25wPPSro8suQ.dat  snap-_uVERtiBQW25wPPSro8suQ.dat
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
```
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ curl -X DELETE --insecure -u elastic "https://localhost:9200/test?pretty"
Enter host password for user 'elastic':
{
  "acknowledged" : true
}
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ curl -X GET --insecure -u elastic "https://localhost:9200/_cat/indices?v=true"
Enter host password for user 'elastic':
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ curl -X PUT --insecure -u elastic "https://localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 1,  
>       "number_of_replicas": 0 
>     }
>   }
> }
> '
Enter host password for user 'elastic':
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ curl -X GET --insecure -u elastic "https://localhost:9200/_cat/indices?v=true"
Enter host password for user 'elastic':
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 Iydkk3U0RVGuP0p2pnK4Cw   1   0          0            0       225b           225b
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
```
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ curl -X GET --insecure -u elastic "https://localhost:9200/_snapshot/netology_backup/*?verbose=false&pretty"
Enter host password for user 'elastic':
{
  "snapshots" : [
    {
      "snapshot" : "my_1st_snap",
      "uuid" : "_uVERtiBQW25wPPSro8suQ",
      "repository" : "netology_backup",
      "indices" : [
        ".geoip_databases",
        ".security-7",
        "test"
      ],
      "data_streams" : [ ],
      "state" : "SUCCESS"
    }
  ],
  "total" : 1,
  "remaining" : 0
}
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ curl -X GET --insecure -u elastic "https://localhost:9200/_snapshot/netology_backup/*?verbose=false&pretty"
Enter host password for user 'elastic':
{
  "snapshots" : [
    {
      "snapshot" : "my_1st_snap",
      "uuid" : "_uVERtiBQW25wPPSro8suQ",
      "repository" : "netology_backup",
      "indices" : [
        ".geoip_databases",
        ".security-7",
        "test"
      ],
      "data_streams" : [ ],
      "state" : "SUCCESS"
    }
  ],
  "total" : 1,
  "remaining" : 0
}
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ curl -X POST --insecure -u elastic "https://localhost:9200/_snapshot/netology_backup/my_1st_snap/_restore?pretty" -H 'Content-Type: application/json' -d'
> {
>   "indices": "*",
>   "include_global_state": true
> }
> '
Enter host password for user 'elastic':
{
  "accepted" : true
}
[elasticsearch@166b74ffb7fb elasticsearch-8.3.3]$ curl -X GET --insecure -u elastic "https://localhost:9200/_cat/indices?v=true"
Enter host password for user 'elastic':
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test   xbOCVBAdSZ6xb6izOkM1vA   1   0          0            0       225b           225b
green  open   test-2 Iydkk3U0RVGuP0p2pnK4Cw   1   0          0            0       225b           225b
```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
