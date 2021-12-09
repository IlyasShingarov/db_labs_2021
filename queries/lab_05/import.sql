-- 2. Импорт из JSON
drop table if exists material_from_json;
CREATE TABLE IF NOT EXISTS material_from_json
(
    material_id SERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(30),
    is_compostable BOOLEAN,
    is_recyclable BOOLEAN,
    saved_energy INT NOT NULL,
    saved_water INT NOT NULL,
    composting_time INT
);

drop table if exists json_temp ;
create table json_temp(row json);
copy json_temp(row) from '/dbdata/material.json';

select x.material_id,
x.name, x.type, x.is_compostable, x.is_recyclable, x.saved_energy, x.saved_water, x.composting_time
into material_from_json 
from json_temp jt, json_to_record(jt.row)
as x(
	material_id int, 
    name VARCHAR,
    type VARCHAR,
    is_compostable BOOLEAN,
    is_recyclable BOOLEAN,
    saved_energy INT,
    saved_water INT,
    composting_time INT);
   
select * from material_from_json;

----------------------------------------------------------

create table temp (data json);
copy temp (data) from '/dbdata/material.json';
insert into material_from_json 
(name, type, is_compostable, is_recyclable, saved_energy, saved_water, composting_time)
select 
data->>'name',
data->>'type',
(data->>'is_compostable')::bool,
(data->>'is_recyclable')::bool,
(data->>'saved_energy')::int,
(data->>'saved_water')::int,
(data->>'composting_time')::int
from temp;

select * from material_from_json;
drop table temp;
drop table material_from_json;

-----------------------------------------------