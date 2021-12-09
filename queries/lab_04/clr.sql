create extension plpython3u;

drop schema if exists clr cascade;
create schema clr;

-- 1. Опр. пользователем скалярная CLR
create or replace function clr.CountByType(mattype varchar)
returns int language plpython3u as $$
	res = plpy.execute(f"\
	select count(*) as meh \
	from product p join disassembly d on p.product_id = d.product_id \
	join material m on d.material_id = m.material_id \
	where m.type = '{mattype}'")
	print(res)
	return res[0]['count'];
$$;

select m.type, clr.CountByType(m.type) as "count" from material m group by m.type;

-- 2. Пользовательская агреггатная функция CLR

drop function clr.AvgPrice();
create or replace function clr.AvgPrice()
returns numeric language plpython3u as $$
	res = plpy.execute(" \
	select sum(p.price) as temp \
	from product p \
	group by p.product_id;")
	return sum(map(lambda x: x['temp'], res)) / len(res)
$$;

select * from clr.AvgPrice();

-- 3. Определяемая пользователем табличная CLR

create or replace function clr.GetByPriceInterval(a int, b int)
returns table (
	product_id int,
	name varchar,
	price int
) language plpython3u as $$
	res = plpy.execute(f"\
	select p.product_id, p.name, p.price \
	from product p \
	where p.price between {a} and {b};")
	for r in res:
		yield (r['product_id'], r['name'], r['price'])
$$;

select * from clr.GetByPriceInterval(30000, 60000);

-- 4. Хранимая процедура CLR

create or replace procedure ChangeMaterialType(cid int, mattype varchar(256))
as $$
	res = plpy.execute(f"\
	update center set material_type = '{mattype}' \
	where center_id = {cid};")
$$ language plpython3u;

select * from center where center_id = 220;
call ChangeMaterialType(220,'sdfsdf');
select * from center where center_id = 220;

-- 5. Триггер CLR


create function clr.aftertrigger() returns trigger
language plpython3u as $$
	res = plpy.execute("\
	update material set is_compostable = false, is_recyclable = false;")
	return None
$$;

drop trigger test_clr_after_trigger on material;
drop ;
create trigger test_clr_after_trigger
after insert on material for each row
execute procedure clr.aftertrigger();

select * from material;
insert into material (name, type, saved_energy, saved_water)
values ('abcdefsfdsasdasda', 'wood', 1, 1);

-- 6. Определяемый пользователем тип CLR

select * from material;

drop type MMaterial cascade;
create type MMaterial as (
	mid int,
	mname varchar,
	is_compostable bool,
	is_recyclable bool,
	composting_time int
);

drop function clr.MaterialInfo(varchar);
create or replace function clr.MaterialInfo(material varchar)
returns setof MMaterial language plpython3u as $$
	res = plpy.cursor(f"\
	select material_id, name, is_compostable, is_recyclable, composting_time \
	from material \
	where type = '{material}';")
	for c in map(lambda c: (c['material_id'], c['name'], c['is_compostable'],\
	c['is_recyclable'], c['composting_time']), res):
		yield c
$$;

select * from clr.MaterialInfo('metal');