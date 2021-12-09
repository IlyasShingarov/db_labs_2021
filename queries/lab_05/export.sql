copy (select array_to_json(array_agg(row_to_json(m))) as "Materials" from material as m) 
to '/dbdata/material.json';

copy ( select row_to_json(material) from material) TO '/dbdata/material.json';