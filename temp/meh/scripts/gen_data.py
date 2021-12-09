# Добавить аттрибут к заводу чтобы он принимал конкретный вид мусора

import random

from faker import Faker

fake = Faker()
fake_ru = Faker(locale="ru_RU")


delim = ';'
name_count = 1000
center_count = 1000

# Generation for Products table
#
# product_id, product_name, product_price, product_weight, product_manufacturer, product_barcode
# 

product_file = open('../../dbdata/product.csv', 'w+')
product_file.write('name;price;weight;manufacturer;barcode\n')

name_list = []
with open('product_names.txt') as f:
    name_list = f.readlines()
    for i in range(len(name_list)):
        name_list[i] = name_list[i].strip()

sample_names = random.sample(name_list, name_count)
random.shuffle(sample_names)
for i in range(name_count):
    product_file.write(
        sample_names[i] + ';' + 
        str(round(random.uniform(100, 100000), 2)) + ';' +
        str(round(random.uniform(100, 10000), 2)) + ';' +
        fake.company() + ';' + fake.ean8() + '\n')


product_file.close()

# Generation for Material table
#
# material_id, material_name, material_сompostable, material_recyclable, material_reusable
#   saved_energy, saved_water, composting_time

metals = [
    "metal",
    "iron",
    "steel",
    "carbon stee",
    "alloy steel",
    "stainless steel",
    "mercury",
    "magnesium",
    "aluminum",
    "copper",
    "lead",
    "zinc",
    "tin",
    "titanium",
    "tungsten",
    "nickel",
    "cobalt",
    "brass",
    "bronze",
    "silver",
    "gold"
]

wood = [
    "wood",
    "cedar",
    "fir",
    "redwood",
    "ash",
    "cherry",
    "mahogany",
    "maple",
    "oak",
    "poplar",
    "teak",
    "walnut",
    "bamboo",
    "pine",
    "birch",
    "plywood",
    "chipboard",
    "hdf",
    "mdf",
    "osb"
]

plastic = [
    "PET",
    "HDPE",
    "PMMA",
    "POM",
    "PA",
    "PVC",
    "LDPE",
    "PP",
    "PS",
    "PLA",
    "PC",
    "ABS",
    "nylon",
    "teflon",
    "PEI",
    "PAI",
    "plastic"
]

fabric = [
    "cotton",
    "viscose",
    "wool",
    "silk",
    "leather",
    "linen",
    "canvas",
    "denim"
]

generic = [
    "glass",
    "felt",
    "paper",
    "carton",
    "cork",
    "composite",
    "battery"
]

material_file = open('../../dbdata/material.csv', 'w+')
material_file.write(
    'name' + delim +
    'type' + delim +
    'compostable' + delim +
    'recyclable' + delim +
    'saved_energy' + delim +
    'saved_water' + delim +
    'composting_time' + '\n'
    )

materials = [metals, wood, plastic, fabric, generic]
material_count = 0
for i in materials: material_count += len(i)

# Metal gen
for i in materials[0]:
    material_file.write(
        str(i) + delim +
        'metal' + delim +
        '0' + delim +
        '1' + delim +
        str(random.randint(1000, 1000000)) + delim +
        str(random.randint(1000, 1000000)) + delim +
        '' + '\n'
    )

# Wood gen
for i in materials[1]:
    material_file.write(
        str(i) + delim +
        'wood' + delim +
        '1' + delim +
        '1' + delim +
        str(random.randint(1000, 10000)) + delim +
        str(random.randint(1000, 10000)) + delim +
        str(random.randint(10, 25) * 365) + '\n'
    )

# Plastic gen
for i in materials[2]:
    recyclable = 1 if i in ('PET', 'HDPE', 'LDPE', 'PP', 'PS', 'ABS') else 0
    material_file.write(
        str(i) + delim +
        'plastic' + delim +
        '1' + delim +
        str(recyclable) + delim +
        str(random.randint(1000, 100000)) + delim +
        str(random.randint(1000, 100000)) + delim +
        str(random.randint(200, 700) * 365) + '\n'
    )

# Fabric gen
for i in materials[3]:
    recyclable = 1
    material_file.write(
        str(i) + delim +
        'fabric' + delim + 
        '1' + delim +
        str(recyclable) + delim +
        str(random.randint(10000, 100000)) + delim +
        str(random.randint(1000, 100000)) + delim +
        str(random.randint(3, 5) * 365) + '\n'
    )

# Generic gen
for i in materials[4]:
    recyclable = 1 if i in ("glass", "paper", "cork") else 0
    compostable = 1 if i in ("paper", "cork") else 0
    material_file.write(
        str(i) + delim +
        delim + 
        str(compostable) + delim +
        str(recyclable) + delim +
        str(random.randint(10000, 100000)) + delim +
        str(random.randint(1000, 100000)) + delim +
        str(random.randint(2, 5) * 365) + '\n'
    )

material_file.close()


# Generation for Disassembly table
#
# product_id, material_id
#   material_yield, disassembly_complexity

disassembly_file = open('../../dbdata/disassembly.csv', 'w+')
disassembly_file.write(
        'product_id' + delim +
        'material_id' + delim +
        'material_yield' + delim +
        'disassembly_complexity' + '\n'
    )

for i in range(name_count):
    m_line_count = random.randint(1, 4)
    mats = random.sample(range(1, material_count), m_line_count)
    for j in range(m_line_count):
        disassembly_file.write(
            str(i + 1) + delim +
            str(mats[j]) + delim + 
            str(round(random.uniform(10, 9999), 3)) + delim +
            str(random.randint(0, 10)) + '\n'
        )

disassembly_file.close()


# Generation for Distribution table
#
# material_id, center_id
#   shipment_amount, shipment_cost, shipment_time

distribution_file = open('../../dbdata/distribution.csv', 'w+')
# distribution_file = open('distribution.csv', 'w+')
distribution_file.write(
        'material_id' + delim +
        'center_id' + delim +
        'shipment_amount' + delim +
        'shipment_cost' + delim +
        'shipment_time' + '\n'
    )

center_ids = list(range(1, 1100))

# ------------Metals------------------------------
metal_centers = {}
for i in range(1, len(metals) + 1):
    c = random.randint(5, 30)
    mmm = []
    for j in range(c):
        cid = random.sample(center_ids, 1)
        center_ids.remove(*cid)
        mmm.extend(cid)
    metal_centers[i] = mmm
    
# ---------------------------------------------

# ------------Wood------------------------------
wood_centers = {}
for i in range(1, len(wood) + 1):
    c = random.randint(5, 15)
    www = []
    for j in range(c):
        cid = random.sample(center_ids, 1)
        center_ids.remove(*cid)
        www.extend(cid)
    wood_centers[i] = www
    
# ---------------------------------------------

# ------------Plastic------------------------------
plastic_centers = {}
for i in range(1, len(plastic) + 1):
    c = random.randint(10, 40)
    ppp = []
    for j in range(c):
        cid = random.sample(center_ids, 1)
        center_ids.remove(*cid)
        ppp.extend(cid)
    plastic_centers[i] = ppp
    
# ---------------------------------------------

# ------------fabric------------------------------
fabric_centers = {}
for i in range(1, len(fabric) + 1):
    c = random.randint(5, 15)
    fff = []
    for j in range(c):
        cid = random.sample(center_ids, 1)
        center_ids.remove(*cid)
        fff.extend(cid)
    fabric_centers[i] = fff
# ---------------------------------------------

print(f'metal -- {metal_centers}\n\nwood -- {wood_centers}\n\n')
print('\n\n\n\n\n\n\n\n\n')
generic_center_ids = center_ids

metal_center_ids = []
for i in metal_centers.keys():
    for j in metal_centers[i]:
        metal_center_ids.append(j)
metal_id_set = set(metal_center_ids)

wood_center_ids = []
for i in wood_centers.keys():
    for j in wood_centers[i]:
        wood_center_ids.append(j)
wood_id_set = set(wood_center_ids)

plastic_center_ids = []
for i in plastic_centers.keys():
    for j in plastic_centers[i]:
        plastic_center_ids.append(j)

fabric_center_ids = []
for i in fabric_centers.keys():
    for j in fabric_centers[i]:
        fabric_center_ids.append(j)

for i in metal_centers.keys():
    for j in metal_centers[i]:
        distribution_file.write(
            f"{i};{j};{random.randint(1, 100)};{round(random.uniform(10000, 50000), 2)};{random.randint(1, 100)}\n"
        )

for i in wood_centers.keys():
    for j in wood_centers[i]:
        distribution_file.write(
            f"{len(metals) + i};{j};{random.randint(1, 100)};{round(random.uniform(10000, 50000), 2)};{random.randint(1, 100)}\n"
        )

print(metal_id_set)
for i in plastic_centers.keys():
    for j in plastic_centers[i]:
        distribution_file.write(
            f"{len(metals) + len(wood) + i};{j};{random.randint(1, 100)};{round(random.uniform(10000, 50000), 2)};{random.randint(1, 100)}\n"
        )

for i in fabric_centers.keys():
    for j in fabric_centers[i]:
        distribution_file.write(
            f"{len(metals) + len(wood) + len(plastic) + i};{j};{random.randint(1, 100)};{round(random.uniform(10000, 50000), 2)};{random.randint(1, 100)}\n"
        )


distribution_file.close()
# centers = {}
# center_set = set()
# for i in range(material_count):
#     c_line_count = random.randint(20, 100)
#     cents = random.sample(range(1, center_count), c_line_count)
#     for c in range(len(cents)):
#         if cents[c] in center_set:
#             cents.pop(c)

#     if i not in (43, 44, 45, 46, 50, 51, 53, 54, 55, 56, 57, 67, 71, 72):
#         purpose = 'composte' if i in range(0, 20) else random.choice(('composte', 'recycle', 'reuse'))
#         for j in range(c_line_count):
#             if cents[j] not in center_set:
#                 distribution_file.write(
#                     str(i + 1) + delim +
#                     str(cents[j]) + delim + 
#                     str(random.randint(1, 100)) + delim +
#                     str(round(random.uniform(10000, 50000), 2)) + delim +
#                     str(random.randint(1, 100)) + '\n'
#                 )
#     centers[i] = cents
#     center_set.union(set(cents))

# Generation for Center table
#
# center_id, center_name, center_city, center_adress, center_phone, center_scale

center_file = open('../../dbdata/center.csv', 'w+')
# center_file = open('center.csv', 'w+')
center_file.write(
        'name' + delim +
        'city' + delim +
        'adress' + delim +
        'phone' + delim +
        'scale' + delim +
        'material_type' + 
        '\n'
    )

for i in range(1,1100):
    if i in metal_id_set:
        center_file.write(
            fake.company() + delim +
            fake.city() + delim + 
            fake.street_address() + delim +
            fake_ru.phone_number() + delim +
            random.choice(['large', 'big', 'medium', 'small', 'tiny']) + delim + 
            "metal" +
            '\n'
        )
    elif i in wood_id_set:
        center_file.write(
            fake.company() + delim +
            fake.city() + delim + 
            fake.street_address() + delim +
            fake_ru.phone_number() + delim +
            random.choice(['large', 'big', 'medium', 'small', 'tiny']) + delim + 
            "wood" +
            '\n'
        )
    elif i in plastic_center_ids:
        center_file.write(
            fake.company() + delim +
            fake.city() + delim + 
            fake.street_address() + delim +
            fake_ru.phone_number() + delim +
            random.choice(['large', 'big', 'medium', 'small', 'tiny']) + delim + 
            "plastic" +
            '\n'
        )
    elif i in fabric_center_ids:
        center_file.write(
            fake.company() + delim +
            fake.city() + delim + 
            fake.street_address() + delim +
            fake_ru.phone_number() + delim +
            random.choice(['large', 'big', 'medium', 'small', 'tiny']) + delim + 
            "fabric" +
            '\n'
        )
    else:
        center_file.write(
            fake.company() + delim +
            fake.city() + delim + 
            fake.street_address() + delim +
            fake_ru.phone_number() + delim +
            random.choice(['large', 'big', 'medium', 'small', 'tiny']) + delim + 
            '\n'
        )

center_file.close()


# for i in range(center_count):
    
#     center_file.write(
#         fake.company() + delim +
#         fake.city() + delim + 
#         fake.street_address() + delim +
#         fake_ru.phone_number() + delim +
#         random.choice(['large', 'big', 'medium', 'small', 'tiny']) + delim + 
        
#         '\n'
#     )
