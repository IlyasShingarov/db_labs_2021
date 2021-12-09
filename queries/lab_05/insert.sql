drop table if exists json_table;
create table json_table(
	material_id serial primary key,
	name varchar,
	json_col json
);

insert into json_table(name, json_col) values 
('lead', '{"type" : "metal", "is_recyclable": true, "inner" : {"smth" : "something_1"}}'::json),
('oak', '{"type" : "wood", "is_recyclable": true, "inner" : {"smth" : "something_2"}}'::json),
('carton', '{"type" : "complex", "is_recyclable": false, "inner" : {"smth" : "somthing_3"}}'::json);

select * from json_table;
drop table json_table;

-- 4. ��������� ���������
-- 1. ������� XML/JSON �������� �� XML/JSON ���������
select * from temp;
select data->'name' as name from temp;
--select * from material_from_json limit 1;

-- 2. ������� �������� ���������� ����� ��� ���������� XML/JSON ���������
select * from json_table;
select json_col->'inner'->'smth' as type from json_table;

select json_col ->>'type' as type, name, json_col->>'is_recyclable' as recyclable
from json_table 
where json_col ->>'type' = 'metal';

-- 3. ��������� �������� ������������� ���� ��� ���������
select json_col, 
	json_col::jsonb ? 'type' as type_exists,
	json_col::jsonb ? 'is_recyclable' as recyclable_exists,
	json_col::jsonb ? 'inner' as inner_exists
from json_table;

-- 4. �������� XML/JSON ��������

update json_table set json_col = jsonb_set(json_col::jsonb, '{is_recyclable}', 'false', false)
where json_col->>'type' = 'wood';

select * from json_table ;

-- 5. ��������� XML/JSON �������� �� ��������� ����� �� �����

SELECT * FROM jsonb_array_elements('[
    {"name": "lead", "type": "metal", "meta": {"is_recyclable": true, "is_compostable": false}},
    {"name": "oak", "type": "wood", "meta": {"is_recyclable": true, "is_compostable": true}}
]');

