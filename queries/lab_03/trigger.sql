-- After

create function after_trigger() returns trigger as
$$
	begin
		update material set is_recyclable = false;
		return new;
	end;
$$ language plpgsql;

create trigger test_after_trigger
after insert on material for each row
execute procedure after_trigger();

select * from material;
insert into material (name, type, is_compostable, saved_energy, saved_water)
values ('abcdef', 'metal', false, 1, 1);
-- Instead of

create view product_new as select * from product;
select * from product_new;

create or replace function del_product_func()
returns trigger 
as $$
	begin 
		update product_new
		set price = 1
		where product_new.product_id = old.product_id;
	return new;
	end;
$$ language plpgsql;

drop trigger del_product_trigger on product_new;
create trigger del_product_trigger
instead of delete on product_new
for each row execute procedure del_product_func();

delete from product_new where price > 50000;


select * from product_new;