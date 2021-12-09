-- 1. Предикат сравнения
-- Вывести название и штрих-код товаров чья цена выше 9000 и вес меньше 2000
select name, barcode from product where (price > 9000) and (weight < 2000);

-- 2. Предикат Between
-- Вывести название, время разложения и сохраняемую энергию материалов которые разлагаютя от 500 до 2000 лет
select name, composting_time, saved_energy from material m where composting_time between 500 and 2000;

-- 3. Предикат like
-- Выбрать продукты, в названии которых содержится подстрока аа
select name from product where name like '%aa%';

-- 4. предикат in с вложенным подзапросом
-- Выбрать имя и цену продуктов сделанных из дерева
select name, price from product 
where product_id in (
	select d.product_id from disassembly d join material m on d.material_id = m.material_id
	where m.type = 'wood'
	);

-- 5. Предикат exists 
-- 
select c.name, c.material_type from center c 
where exists (
	select * from material m where c.material_type = m.type and m.name = 'lead'
);

-- 6. Предикат сравнения с квантором
-- Выбрать те продукты, чья цена больше всех тех, что весят больше 5000
select * from product
where price > all (
	select price from product 
	where weight > 5000
);

-- 7. агрегатные функции в выражениях столбцов
--
select avg(price) as avgp , max(price) as maxp from product;
select count(name) as ct, type from material m group by type;

-- 8. Скалярные подзапросы в выражениях столбцов
--
select name, (select min(price) from product) as minp, (select max(price) from product) as maxp from product 
where name like 'A%';

-- 9. простое выражение CASE.
select name, price,
case price
when (
	select max(price) from product
)
then 'Максимальная цена'
when (
	select min(price) from product
)
then 'Минимальная цена'
else 'Средняя цена'
end as comment
from product ;

-- 10. поисковое выражение CASE.

select name, price,
case
when price < (
		select avg(price) from product
	)
	then 'Продукт доступный'
	else 'Цена выше средней'
	end as comment
from product ;

-- 11. Создание новой временной локальной таблицы.
select type, count(name) into typecounts from material group by type;
select * from typecounts;
drop table if exists typecounts;


-- 12. Вложенные коррелированные подзапросы в качестве 
-- производных таблиц в предложении FROM.

select name, price from product p join (
	select * from disassembly where disassembly_complexity > 5
) as sq on p.product_id = sq.product_id;

-- 13. вложенные подзапросы с уровнем вложенности 3
select product_id, name
from product
where product_id in (
    select product_id
    from disassembly
    group by product_id
    having avg(disassembly_complexity) in (
        select avg(disassembly_complexity) 
        from (
        	select product_id, disassembly_complexity from disassembly d 
        	join material m on d.material_id = m.material_id
        	where m.type = 'metal'
        ) as sq
        group by product_id
    )
);

-- 14. предложения GROUP BY, но без предложения HAVING.
SELECT type, COUNT(name) as cnt, avg(saved_energy) as saved_avg
FROM material m 
GROUP BY type;

-- 15. предложения GROUP BY и предложения HAVING
select * from center c ;
select scale, count(center_id)
from center c 
group by scale, material_type
having material_type = 'metal';

-- 16.Однострочная инструкция INSERT,
-- выполняющая вставку в таблицу одной строки значений.
select * from material;
insert into material(name, type, is_compostable, is_recyclable, saved_energy, saved_water)
values ('aaaaname', 'aaaatype', false, true, 1000, 1000);
select * from material where name like '%aaa%';

-- 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу
-- результирующего набора данных вложенного подзапроса.
INSERT INTO material (material_id, name, type, is_compostable, is_recyclable, saved_energy, saved_water)
SELECT (
	SELECT max(material_id) + 1000
	FROM material
	WHERE material.type = 'fabric'
), 'aaaaaa','bbbb', FALSE, false, 100, 100;

select * from material m where name like '%aaaa%';

-- 18. Простая инструкция UPDATE.
select price, name, manufacturer from product where product_id = 100;
update product set price = price * 0.5, manufacturer = 'bmstu' where product_id = 100;

-- 19. Инструкция UPDATE со скалярным подзапросом в предложении SET.
UPDATE product
SET price = (
	SELECT max(price)
	FROM product
)
WHERE product_id = 20;

select product_id, price from product p where product_id = 20;

-- 20. Простая инструкция DELETE.
select * from center c where material_type is null;
delete from center where material_type is null;

-- 21. Инструкция DELETE с вложенным коррелированным
-- подзапросом в предложении WHERE.
select * from distribution d ;
delete from center c where center_id in (
	select center_id from distribution where shipment_cost > 20000
)

-- 22. Инструкция SELECT, использующая
-- простое обобщенное табличное выражение
with cte(cid, cprice, ctype) as (
	select p.product_id, p.price, m.type from product p 
	join disassembly d on p.product_id = d.product_id
	join material m on d.material_id = m.material_id
)
select avg(cprice) as avgprice, ctype from cte group by ctype;

-- 23. Инструкция SELECT, использующая
-- рекурсивное обобщенное табличное выражение.

with recursive AsciiCode as (
    select ascii('A') as code
),
RecursiveReplace(Name, Code, Replaced) as (
    select name as Name,
        Code,
        replace(
            concat(
                upper(left(name, 1)),
                upper(substring(name, 2, length(name) - 1))
            ),
            concat(' ', cast(Code as char)),
            concat(' ', cast(Code as char))
        ) as Replaced
    from AsciiCode,
        material
    union all
    select name,
        Code + 1 as Code,
        replace(
            Replaced,
            concat(' ', cast((Code + 1) as char)),
            concat(' ', cast((Code + 1) as char))
        ) as Replaced
    from RecursiveReplace
    where Code < ascii('Z')
)
select Name,
    Replaced
from RecursiveReplace
where code = ascii('Z');

select * from product p ;
insert into product (name, price, weight, manufacturer, barcode)
values ('fdsafa', 123, 123, 'Norton-Johnson', 000000);

WITH RECURSIVE meh AS (
	SELECT
		name,
		product_id,
		manufacturer 
	FROM
		product
	WHERE
		product_id = 234
	UNION
		SELECT
			p.name, p.product_id, p.manufacturer 
		FROM
			product p 
		JOIN meh ON meh.manufacturer = p.manufacturer 
) select * from meh;

-- 24. Оконные функции.
-- Использование конструкций MIN/MAX/AVG OVER()

SELECT type,
AVG(price) OVER(PARTITION BY sq.type) AS AvgPrice,
MIN(price) OVER(PARTITION BY sq.type) AS MinPrice,
MAX(price) OVER(PARTITION BY sq.type) AS MaxPrice
FROM (
	select * from product p 
	join disassembly d on p.product_id = d.product_id 
	join material m on d.material_id = m.material_id
) as sq;

-- 25. Оконные фнкции для устранения дублей
CREATE TABLE test (
    name VARCHAR NOT NULL,
    city VARCHAR NOT NULL
);
INSERT INTO test (name, city) VALUES ('Petya', 'Moscow'), ('Petya', 'Moscow');
WITH test_deleted AS
(DELETE FROM test RETURNING *),
test_inserted AS
(SELECT name, city, ROW_NUMBER() OVER(PARTITION BY name, city ORDER BY name, city) rownum FROM test_deleted)
INSERT INTO test SELECT name,city FROM test_inserted WHERE rownum = 1;
select * from test;
DROP TABLE test;