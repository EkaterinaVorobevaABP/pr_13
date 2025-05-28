# Практическая работа №13
# Цели:
Научиться читать и анализировать планы выполнения (EXPLAIN), сравнить разные типы запросов (JOIN, GROUP BY, подзапросы), найти способы ускорить запросы
# 1. Создайте таблицу tablel со следующими параметрами: Поля: idl int, id2 int, geni text, gen2 text. Сделайте поля id1, id2, gen1 первичным ключом.
  ```
create table table1 (
    id1 INT,
    id2 INT,
    gen1 TEXT,
    gen2 TEXT,
    primary key (id1, id2, gen1)
)
```

![image](https://github.com/user-attachments/assets/6d692caf-6476-41a5-95eb-c8eef440c252)
# 2. Создайте таблицу table? со следующими параметрами: возьмите набор полей table1 с помощью директивы LIKE.
```
create table table2 (
    like table1 including all
);
```
![image](https://github.com/user-attachments/assets/aaca959b-3902-40a6-9861-6873b1bd64de)
Посмотрим ERD-диаграмму
![image](https://github.com/user-attachments/assets/c4983da7-697a-4e1f-afad-dfd5e3d38805)

# 3. Проверить, сколько внешних таблиц присутствует в БД
```
select count(*) as Foreign_tables from information_schema.foreign_tables

```
![image](https://github.com/user-attachments/assets/b90e7d6e-bff9-417e-b367-9fd7745ec668)
# 4. Сгенерируйте данные и вставьте их в обе таблицы (200 тысяч и 400 тысяч значений соответственно)
```
-- Для table1
insert into table1 (id1, id2, gen1, gen2)
select 
    gen as id1,
    gen as id2, 
    gen::text || 'text1' AS gen1,
    gen::text || 'text2' AS gen2
from generate_series(1, 2000000) gen;

-- Для table2
insert into table2 (id1, id2, gen1, gen2)
select 
    gen as id1,
    gen as id2, 
    gen::text || 'text1' AS gen1,
    gen::text || 'text2' AS gen2
from generate_series(1, 400000) gen;
```
![image](https://github.com/user-attachments/assets/8cf5ada5-b616-4994-99c7-d18ff8b5eae9)
# 5. С помощью директивы EXPLAIN просмотрите план объединения таблиц table1 и table2 по ключу id1.
```
explain select *
from table1
join table2 on table1.id1 = table2.id1;
```
![image](https://github.com/user-attachments/assets/e457df0d-fd69-4a36-856e-aa617265c07a)
# 6. Используя таблицы table1 и table2, реализуйте план запроса: План запроса встроенного инструмента pgAdmin
![image](https://github.com/user-attachments/assets/79be0f82-23f6-45ea-8d90-9163b7f1cdc5)
# 7. Реализовать запросы с использованием объединений, группировки, вложенного подзапроса. Экспортировать план в файл
Для достижения наилучших результатов используйте EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
```
select *
from table1
join table2 on table1.id1 = table2.id1;
```
![image](https://github.com/user-attachments/assets/4ad9fd09-afe1-45e1-9d2e-3e23895cec24)

```
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select *
from table1
join table2 on table1.id1 = table2.id1;
```
![image](https://github.com/user-attachments/assets/ea4fa782-13ce-4650-9535-02aa469f8a2d)
![image](https://github.com/user-attachments/assets/3d9eeff0-c5e2-4860-8c40-d4ed9df99eea)


```
select id1, count(*) as rowss
from table1
group by id1;
```
![image](https://github.com/user-attachments/assets/2cbbb5a4-d5f3-437e-bf38-7c87bd872ffc)

```
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select id1, count(*) as rowss
from table1
group by id1;
```
![image](https://github.com/user-attachments/assets/fe885c7d-e900-4e93-8e7d-24f3e360c287)
![image](https://github.com/user-attachments/assets/ad1ba3a9-2e64-4d85-a4a2-ebbad5cb92a5)

```
select *
from table1
where id1 = (select max(id1) from table1);
```
![image](https://github.com/user-attachments/assets/cf7cb9dc-b479-42a7-bd85-e6a8c32c9a1b)


```
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select *
from table1
where id1 = (select max(id1) from table1)
```
![image](https://github.com/user-attachments/assets/a3ece1d9-09ec-474c-9e54-36d2398b9f99)

![image](https://github.com/user-attachments/assets/07bf60a2-ee7b-4ab9-b392-67a0f63b1cce)
# 8. Сравните полученные результаты в пункте 13.6 локально с результатом на сайте https://tatiyants.com/pev/#f/plans/new и сделайте вывод.
![image](https://github.com/user-attachments/assets/5789626c-b44c-46bf-8d50-95549091797d)

![image](https://github.com/user-attachments/assets/fb6794aa-e316-417d-b51a-757453c880ba)


# Вывод:
В ходе работы был освоен анализ плана SQL запросов, проанализированы разные агрегированные функции в запросах
