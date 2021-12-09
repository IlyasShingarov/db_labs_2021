drop table if exists product cascade; 
drop table if exists material cascade; 
drop table if exists center cascade; 
drop table if exists disassembly cascade; 
drop table if exists distribution cascade; 


CREATE TABLE IF NOT EXISTS public.product
(
    product_id SERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    weight DECIMAL(10,2) NOT NULL,
    manufacturer VARCHAR(200) NOT NULL,
    barcode INT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS public.material
(
    material_id SERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    is_compostable BOOLEAN,
    is_recyclable BOOLEAN,
    saved_energy INT NOT NULL,
    saved_water INT NOT NULL,
    composting_time INT
);

CREATE TABLE IF NOT EXISTS public.center
(
    center_id SERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    adress VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    scale VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.disassembly
(
    product_id SERIAL NOT NULL,
    material_id SERIAL NOT NULL,
    material_yield DECIMAL(10, 2) NOT NULL,
    disassembly_complexity INT NOT NULL
);

CREATE TABLE IF NOT EXISTS public.distribution
(
    material_id SERIAL NOT NULL,
    center_id SERIAL NOT NULL,
    shipment_amount INT NOT NULL,
    shipment_cost DECIMAL(10, 2) NOT NULL,
    shipment_time INT NOT NULL
);

ALTER TABLE postgres.public.product 
ADD CONSTRAINT PRKEY_product PRIMARY KEY (product_id),
ADD CONSTRAINT PRICE_check CHECK (price > 0 AND price <= 100000),
ADD CONSTRAINT UNKEY_barcode UNIQUE (barcode);

ALTER TABLE postgres.public.material 
ADD CONSTRAINT PRKEY_material PRIMARY KEY (material_id),
ADD CONSTRAINT ENERGY_check CHECK (material.saved_energy > 0 AND material.saved_energy <= 1000000),
ADD CONSTRAINT WATER_check check (material.saved_water > 0 and material.saved_water <= 10000000);

ALTER TABLE postgres.public.center 
ADD CONSTRAINT PRKEY_center PRIMARY KEY (center_id),
ADD CONSTRAINT UNKEY_phone UNIQUE (phone);

ALTER TABLE postgres.public.disassembly 
ADD CONSTRAINT FKEY_product FOREIGN KEY (product_id) references product (product_id),
ADD CONSTRAINT FKEY_material FOREIGN KEY (material_id) references material (material_id),
ADD CONSTRAINT YIELD_check CHECK (material_yield> 0);

ALTER TABLE postgres.public.distribution
ADD CONSTRAINT FKEY_material FOREIGN KEY (material_id) references material (material_id),
ADD CONSTRAINT FKEY_center FOREIGN KEY (center_id) references center (center_id),
ADD CONSTRAINT NONZERO_check check (shipment_amount > 0 and shipment_cost > 0 and shipment_time > 0);






COPY public.product(name, price, weight, manufacturer, barcode) FROM '/home/ilyas/db/scripts/product.csv' DELIMITER ';'  CSV HEADER;

COPY public.material(name, is_compostable, is_recyclable, saved_energy, saved_water, composting_time) FROM '/home/ilyas/db/scripts/material.csv' DELIMITER ';' CSV HEADER;

COPY public.center(name, city, adress, phone, scale) FROM '/home/ilyas/db/scripts/center.csv' DELIMITER ';' CSV HEADER;

COPY public.disassembly(product_id, material_id, material_yield, disassembly_complexity) FROM '/home/ilyas/db/scripts/disassembly.csv' DELIMITER ';' CSV HEADER;

COPY public.distribution(material_id, center_id, shipment_amount, shipment_cost, shipment_time) FROM '/home/ilyas/db/scripts/distribution.csv' DELIMITER ';' CSV HEADER;

