\COPY public.product(product_id, name, price, weight, manufacturer, barcode) FROM './product.csv' DELIMITER ';'  CSV HEADER;

\COPY public.material(material_id, name, is_compostable, is_recyclable, saved_energy, saved_water, composting_time) FROM './material.csv' DELIMITER ';' CSV HEADER;

\COPY public.center(center_id, name, city, adress, phone, scale) FROM './center.csv' DELIMITER ';' CSV HEADER;

\COPY public.disassembly(product_id, material_id, material_yield, disassembly_complexity) FROM './disassembly.csv' DELIMITER ';' CSV HEADER;

\COPY public.distribution(material_id, center_id, shipment_amount, shipment_cost, shipment_time) FROM './distribution.csv' DELIMITER ';' CSV HEADER;

