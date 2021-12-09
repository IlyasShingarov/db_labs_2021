COPY public.product(name, price, weight, manufacturer, barcode) FROM '/dbdata/product.csv' DELIMITER ';'  CSV HEADER;

COPY public.material(name, type, is_compostable, is_recyclable, saved_energy, saved_water, composting_time) FROM '/dbdata/material.csv' DELIMITER ';' CSV HEADER;

COPY public.center(name, city, adress, phone, scale, material_type) FROM '/dbdata/center.csv' DELIMITER ';' CSV HEADER;

COPY public.disassembly(product_id, material_id, material_yield, disassembly_complexity) FROM '/dbdata/disassembly.csv' DELIMITER ';' CSV HEADER;

COPY public.distribution(material_id, center_id, shipment_amount, shipment_cost, shipment_time) FROM '/dbdata/distribution.csv' DELIMITER ';' CSV HEADER;
