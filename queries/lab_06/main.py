import psycopg2
import os
from tabulate import tabulate
from psycopg2.extras import Json
import json

con = psycopg2.connect(
    dbname = "postgres",
    user = "postgres",
)


def query_1():
    print('\n1.-----------Средняя цена продуктов----------------------')
    cur = con.cursor()
    try:
        cur.execute('''
            select avg(price) as avgPrice, sum(price) / count(*) as calculated
            from product; 
        ''')
        headers = [d[0] for d in cur.description]
        print(tabulate(cur.fetchall(), headers=headers))
        cur.close()
    except:
        con.rollback()
    else:
        con.commit()

def query_2():
    print('\n2. -------------Все продукты содержащие металл------------------')
    cur = con.cursor()
    try:
        cur.execute('''
            select p.product_id, p.name, p.price
            from product p join disassembly d on p.product_id = d.product_id
            join material m on d.material_id = m.material_id
            where m.type = 'metal'
            group by p.product_id;
        ''')
        headers = [d[0] for d in cur.description]
        print(tabulate(cur.fetchall(), headers=headers))
        cur.close()
    except:
        con.rollback()
    else:
        con.commit()
def query_3():
    print('\n3. ----------Средняя цена продукта по типу материала-----------')
    cur = con.cursor()
    try:
        cur.execute('''
            with cte(cid, cprice, ctype) as (
	            select p.product_id, p.price, m.type from product p 
	            join disassembly d on p.product_id = d.product_id
	            join material m on d.material_id = m.material_id
            )
            select cid as id,
            avg(cprice) over (partition by ctype) as avgp
            from cte;
        ''')
        headers = [d[0] for d in cur.description]
        print(tabulate(cur.fetchall(), headers=headers))
        cur.close()
    except:
        con.rollback()
    else:
        con.commit()
def query_4():
    print('\n4. ------Список всех таблиц в базе--------------------')
    cur = con.cursor()
    try:
        cur.execute('''
        select table_catalog as db, table_schema as schema, table_name as table
        from information_schema.tables where table_schema = 'public'
        ''')
        headers = [d[0] for d in cur.description]
        print(tabulate(cur.fetchall(), headers=headers))
        cur.close()
    except:
        con.rollback()
    else:
        con.commit()
def query_5():
    print('\n5. --------Средняя сложность по айди продукта----------')
    id = int(input('Введите айди продукта: '))
    cur = con.cursor()
    try:
        cur.execute(f''' 
            select avg_complexity({id});
        ''')
        headers = [d[0] for d in cur.description]
        print(tabulate(cur.fetchall(), headers=headers))
        cur.close()
    except:
        con.rollback()
    else:
        con.commit()
def query_6():
    print('\n6. --------Центры по типу принимаемого материала----------')
    material = input('Введите тип материала: ')
    cur = con.cursor()
    try:
        cur.execute(f''' 
            select * from get_accepted_material_type('{material}');
        ''')
        headers = [d[0] for d in cur.description]
        print(tabulate(cur.fetchall(), headers=headers))
        cur.close()
    except:
        con.rollback()
    else:
        con.commit()
def query_7():
    print('\n7. ---------По типу материала и максимальной сохранённой воде получить материалы ---------')
    material = input('Введите тип материала: ')
    maxwater = int(input('Введите максимальное количество сохранённой воды: '))
    cur = con.cursor()
    try:
        cur.execute(f''' 
            call fetch_material_by_type('{material}', {maxwater});
        ''')
        for i in con.notices: print(i)
        cur.close()
    except:
        con.rollback()
    else:
        con.commit()
def query_8():
    print('\n8. -----Имя текущей бд------------\n')
    cur = con.cursor()
    try:
        cur.execute(f''' 
            select * from current_catalog;
        ''')
        headers = [d[0] for d in cur.description]
        print(tabulate(cur.fetchall(), headers=headers))
        cur.close()
    except:
        con.rollback()
    else:
        con.commit()
def query_9():
    print('\n9. ------------Создаём таблицу производителя-------------')
    cur = con.cursor()
    try:
        cur.execute('''
            create table if not exists manufacturer(
                m_id serial primary key,
                m_name varchar(256) not null,
                m_city varchar(256) not null,
                m_is_sustainable bool
            )
        ''')
        cur.close()
    except:
        con.rollback()
    else:
        con.commit()
def query_10():
    print('\n10. ----- Вставка значений в таблицу производителя----')
    cur = con.cursor()
    name = input('Введите название компании: ')
    city = input('Введите расположение: ')
    sus = input('Следует ли идеям устойчивого развития(true/false): ')
    try:
        cur.execute(f'''
            insert into manufacturer(m_name, m_city, m_is_sustainable)
            values ('{name}', '{city}', {sus});
            select * from manufacturer;
        ''')
        headers = [d[0] for d in cur.description]
        print(tabulate(cur.fetchall(), headers=headers))
        cur.close()
    except:
        con.rollback()
    else:
        con.commit()

def query_11():
    print('\n Процедура: по продукту выдаём список центров в конкретном городе с указанием типа материала')
    id =  int(input('Введите айди продукта: '))
    city = 'South'
    cur = con.cursor()
    try:
        cur.execute(f'''
            select p.name, c.name, c.city, c.material_type
            from product p 
            join disassembly d on p.product_id = d.product_id
            join material m on d.material_id = m.material_id
            join distribution d2 on m.material_id = d2.material_id 
            join center c on d2.center_id = c.center_id
            where c.city like '%{city}%' and p.product_id = {id};
        ''')
        r = [dict((cur.description[i][0], value) for i, value in enumerate(row)) for row in cur.fetchall()]
        print(json.dumps(r, indent=4, sort_keys=True))
        cur.close()
    except:
        con.rollback()
    else:
        con.commit()
    pass

def draw_menu():
    print("\n\
1.  Выполнить скалярный запрос\n\
2.  Выполнить запрос с несколькими соединениями\n\
3.  Выполнить запрос с ОТВ и оконными функциями\n\
4.  Выполнить запрос к метаданным\n\
5.  Вызвать скалярную функцию\n\
6.  Вызвать табличную функцию\n\
7.  Вызвать хранимую процедуру\n\
8.  Вызвать системную функцию или процедуру\n\
9.  Создать таблицу в базе данных, соответствующую тематике БД\n\
10. Выполнить вставку данных в созданную таблицу\n\
11. Защитаn\n\
12. Завершить работу\n\
    ")

queries = [
    '__empty__',
    query_1, query_2, query_3, query_4, query_5,
    query_6, query_7, query_8, query_9, query_10, query_11,
    lambda: ("Выход...")
]

__exit = len(queries) - 1
if __name__ == '__main__':
    command = -1
    while command != __exit:
        draw_menu()
        command = int(input('>> '))
        queries[command]()
    con.close()

