import random

from time import sleep
from datetime import datetime

import json

delim = ';'
name_count = 10
center_count = 10

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

def gen():
    arr = []
    for _ in range(4):
        name = random.choice(metals)
        _type = 'metal'
        time1 = str(random.randint(1000, 1000000))
        time2 = str(random.randint(1000, 1000000))
        
        rec = {
            'name' : name,
            'type' : _type,
            'is_compostable' : 0,
            'is_recyclable' : 1,
            'saved_energy' : time1,
            'saved_water' : time2
        }
        arr.append(rec)
    return json.dumps(arr)

if __name__ == '__main__':
    fid = 1
    table = 'product'
    while True:
        time = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
        with open(f'{fid}_{table}_{time}.json', 'w') as f:
            f.write(gen())
        fid += 1
        sleep(30)