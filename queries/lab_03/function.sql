-- Скалярная функция
select * from disassembly;
select * from product;
drop function avg_complexity(int);
create or replace function avg_complexity(iid int) 
returns numeric
as $$
(
	select avg(disassembly.disassembly_complexity)
	from product join disassembly 
	on product.product_id = disassembly.product_id
	where product.product_id = iid
);
$$ language sql;
select avg_complexity(1);

-- Подставляемая табличная функция

create or replace function get_by_scale(c_scale varchar(30))
returns setof center
as $$
	select *
	from center
	where scale = c_scale;
$$ language sql;

select * from get_by_scale('big');
-- Многооператорная табличная функция

create or replace function get_accepted_material_type(acceptedtype varchar(256))
returns table
(
	out_id int,
	out_name varchar(256),
	out_type varchar(256)
)
as $$
begin
	return query
		select center.center_id, center.name, center.material_type
		from center 
		where center.material_type = acceptedtype;
end;
$$ language plpgsql;

select * from get_accepted_material_type('metal');

-- Рекурсивная функция или функция с рекурсивным ОТВ

create or replace function recFunc(pid int, minprice int)
returns setof product
as $$
begin 
	return query
	(
		select *
		from product
		where product.price > minprice and product.product_id = pid
	);
	if (pid > 2) then
		return query
		select *
		from recFunc(pid - 1, minprice);
	end if;
end;
$$ language plpgsql;

select * from recFunc(40, 50000);