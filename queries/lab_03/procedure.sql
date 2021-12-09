-- 1. Хранимая процедура без параметров или с параметрами
drop table if exists product_copy;
select * into temp product_copy from product;
create or replace procedure delete_heavy_products()
as $$
	delete from product_copy
	where weight > 2000;
$$ language sql
call delete_heavy_products();
select * from product_copy;

-- Рекурсивная хранимая процедура или хранимая процедура с рекурсивным ОТВ

drop procedure raise_price(integer, integer);

create or replace procedure raise_price(pid int, pprice int)
as $$
	begin
		update product 
		set price = price + 1
		where price < pprice and product_id = pid;
	if (pid > 2) then
			call raise_price(pid - 1, pprice);
	end if;
	end;
$$ language plpgsql;

call raise_price(100, 100000);

select * from product where product_id < 10;

-- Хранимая процедура с курсором

create or replace procedure fetch_material_by_type(mattype varchar, savedwater int)
as $$
declare 
	recmat record;
	matcur cursor for
		select * from material
		where material.type = mattype and material.saved_water < savedwater;
begin
	open matcur;
	loop
		fetch matcur into recmat;
		exit when not found;
		raise notice '% % %', recmat.name, recmat.type, recmat.saved_water;
	end loop;
	close matcur;
end;
$$ language plpgsql;

call fetch_material_by_type('wood', 2000);

-- Хранимая процедура доступа к метаданным
create or replace procedure count_funcs()
language plpgsql as $$
declare 
	num int;
begin
	num := (
	select count(*) 
	from pg_catalog.pg_proc
	where pronamespace = (
		select oid
		from pg_catalog.pg_namespace 
		where nspname = 'public'
		)
	);
	raise notice '% functions and procedures created', num;
end;
$$;

call count_funcs();