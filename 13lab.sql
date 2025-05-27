-- 13.1 Создание таблицы table1
 create table table1 (
    id1 INT,
    id2 INT,
    gen1 TEXT,
    gen2 TEXT,
    primary key (id1, id2, gen1)
);

-- 13.2 Создание таблицы table2 с использованием LIKE
create table table2 (
    like table1 including all -- Включаем все атрибуты, такие как ограничения и индексы
);

-- 13.3 Проверка количества внешних таблиц в БД
select count(*) as Foreign_tables from information_schema.foreign_tables

-- 13.4 Сгенерируйте данные в таблицы
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

--13.5 Посмотрите план соединения таблиц
explain select *
from table1
join table2 on table1.id1 = table2.id1;

-- 13.7 Реализуйте запросы с Group by, join, вложенным подзапросом и план для них
select *
from table1
join table2 on table1.id1 = table2.id1;

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select *
from table1
join table2 on table1.id1 = table2.id1;


select id1, count(*) as rowss
from table1
group by id1;

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select id1, count(*) as rowss
from table1
group by id1;

select *
from table1
where id1 = (select max(id1) from table1);

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select *
from table1
where id1 = (select max(id1) from table1)

