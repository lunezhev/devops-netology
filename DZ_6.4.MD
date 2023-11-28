# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
```
version: '3.9'
services:
  postgres:
    image: postgres:13
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_USER=postgres
    volumes:
      - ./data:/var/lib/postgresql/data
      - ./backup:/data/backup/postgres
    ports:
      - "5432:5432"
    restart: always
```
Подключитесь к БД PostgreSQL используя `psql`.


Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
```
and=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
-----------+-------+----------+------------+------------+-------------------
 and       | and   | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres  | and   | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | and   | UTF8     | en_US.utf8 | en_US.utf8 | =c/and           +
           |       |          |            |            | and=CTc/and
 template1 | and   | UTF8     | en_US.utf8 | en_US.utf8 | =c/and           +
           |       |          |            |            | and=CTc/and
(4 rows)
```
- подключения к БД
```
and=# \c postgres
You are now connected to database "postgres" as user "and".
```
- вывода списка таблиц
```
postgres=# \dt
Did not find any relations.
```
- вывода описания содержимого таблиц
```
postgres=# \d pg_database
               Table "pg_catalog.pg_database"
    Column     |   Type    | Collation | Nullable | Default 
---------------+-----------+-----------+----------+---------
 oid           | oid       |           | not null | 
 datname       | name      |           | not null | 
 datdba        | oid       |           | not null | 
 encoding      | integer   |           | not null | 
 datcollate    | name      |           | not null | 
 datctype      | name      |           | not null | 
 datistemplate | boolean   |           | not null | 
 datallowconn  | boolean   |           | not null | 
 datconnlimit  | integer   |           | not null | 
 datlastsysoid | oid       |           | not null | 
 datfrozenxid  | xid       |           | not null | 
 datminmxid    | xid       |           | not null | 
 dattablespace | oid       |           | not null | 
 datacl        | aclitem[] |           |          | 
Indexes:
    "pg_database_datname_index" UNIQUE, btree (datname), tablespace "pg_global"
    "pg_database_oid_index" UNIQUE, btree (oid), tablespace "pg_global"
Tablespace: "pg_global"
```
- выхода из psql
```
postgres=# \q
```


## Задача 2

Используя `psql` создайте БД `test_database`.
```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```
root@4839b6c84b38:/# psql -U postgres test_database < /data/backup/postgres/test_dump.sql
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
```

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```
root@4839b6c84b38:/# psql -U postgres
psql (13.8 (Debian 13.8-1.pgdg110+1))
Type "help" for help.

postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \d
              List of relations
 Schema |     Name      |   Type   |  Owner   
--------+---------------+----------+----------
 public | orders        | table    | postgres
 public | orders_id_seq | sequence | postgres
(2 rows)

test_database=# analyze verbose public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
```
test_database=# select max(avg_width) from pg_stats where tablename= 'orders';
 max 
-----
  16
(1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
```
Разбить по диапазонам)))
test_database=# create table orders_u499 as select * from orders where (price <='499');
SELECT 5
test_database=# create table orders_o499 as select * from orders where (price >'499');
SELECT 3
```
```
Декларативное секционирование
test_database=# alter table orders rename to old_orders;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_2 partition of orders for values from ('0') to ('500');
CREATE TABLE
test_database=# create table orders_1 partition of orders for values from ('500') to (maxvalue);
CREATE TABLE
test_database=# insert into orders select * from old_orders;
INSERT 0 8
```
```
test_database=# TABLE orders_1;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# TABLE orders_2;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)

test_database=# TABLE orders_o499;
 id |       title        | price 
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=# TABLE orders_u499;
 id |        title         | price 
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)
```
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
```
Да, возможно, использовав вариант с секционированием.
```
## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```
root@523a4d5f3247:/# pg_dump -U postgres -v -f /data/backup/postgres/test_dump_new.sql
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
```
test_database=# alter table old_orders add constraint title_unique unique (title);
ALTER TABLE
```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
