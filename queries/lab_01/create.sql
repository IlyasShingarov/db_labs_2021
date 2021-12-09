CREATE TABLE IF NOT EXISTS public.product
(
    product_id SERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10) NOT NULL,
    weight DECIMAL(10) NOT NULL,
    manufacturer VARCHAR(200) NOT NULL,
    barcode INT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS public.material
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

CREATE TABLE IF NOT EXISTS public.center
(
    center_id SERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    adress VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    scale VARCHAR(20) NOT NULL,
    material_type VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS public.disassembly
(
    product_id SERIAL NOT NULL,
    material_id SERIAL NOT NULL,
    material_yield DECIMAL(10) NOT NULL,
    disassembly_complexity INT NOT NULL
);

CREATE TABLE IF NOT EXISTS public.distribution
(
    material_id SERIAL NOT NULL,
    center_id SERIAL NOT NULL,
    shipment_amount INT NOT NULL,
    shipment_cost DECIMAL(10) NOT NULL,
    shipment_time INT NOT NULL
);