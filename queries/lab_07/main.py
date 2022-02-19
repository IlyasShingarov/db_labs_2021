import json
import os
import decimal
from tabulate import tabulate

from sqlalchemy import create_engine, engine, text, MetaData
from sqlalchemy.orm import mapper, Session, query

pgdb = 'postgres'
pguser = 'postgres'
pghost = 'localhost'
pgport = '5432'
connect_string = f'postgresql+psycopg2://{pguser}@{pghost}:{pgport}/{pgdb}'
engine = create_engine(connect_string)
meta = MetaData()
meta.reflect(bind=engine, schema='public')

class Product:
    def __init__(self, name, price, weight, manufacturer, barcode):
        self.name = name
        self.price = price
        self.weight = weight
        self.manufacturer = manufacturer
        self.barcode = barcode

class Material:
    def __init__(self, name, type, is_compostable, is_recyclable, saved_energy, saved_water, composting_time):
        self.name = name
        self.type = type
        self.is_compostable = is_compostable
        self.is_recyclable = is_recyclable
        self.saved_energy = saved_energy
        self.saved_water = saved_water
        self.composting_time = composting_time
        

class Center:
    pass

class Distribution:
    pass

class Disassembly:
    pass


def count_materials():
    id = str(input('Введите id товара: '))
    con = Session(bind=engine)
    query = text('select count(*) '
        'from public.product p join public.disassembly d on p.product_id = d.product_id '
        'where p.product_id = :id').bindparams(id = id)
    cnt = con.execute(query).fetchone()[0]
    con.close()
    print(cnt)
































execute = [
    '__empty__',
    count_materials
]

__exit = len(execute) - 1
if __name__ == '__main__':
    command = -1
    while command != __exit:
        # draw_menu()
        command = int(input('>> '))
        execute[command]()