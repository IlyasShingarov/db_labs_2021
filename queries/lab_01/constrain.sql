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
ADD CONSTRAINT YIELD_check CHECK (material_yield > 0);

ALTER TABLE postgres.public.distribution
ADD CONSTRAINT FKEY_material FOREIGN KEY (material_id) references material (material_id),
ADD CONSTRAINT FKEY_center FOREIGN KEY (center_id) references center (center_id) on delete cascade,
ADD CONSTRAINT NONZERO_check check (shipment_amount > 0 and shipment_cost > 0 and shipment_time > 0);