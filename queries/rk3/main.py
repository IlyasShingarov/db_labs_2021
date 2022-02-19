import os
import psycopg2
from tabulate import tabulate
from py_linq import Enumerable

# Варинат 4

# con = psycopg2.connect(
#     dbname = "postgres",
#     user = "postgres",
# )

from playhouse.db_url import connect
from playhouse.shortcuts import Cast
import peewee as pw

db = connect("postgresql://localhost:5432/rk3?user=postgres")


class BaseModel(pw.Model):
    class Meta:
        database = db


class Employee(BaseModel):
    id = pw.PrimaryKeyField()
    e_name = pw.CharField()
    brithday = pw.DateField()
    department = pw.CharField()


class Entries(BaseModel):
    id = pw.ForeignKeyField(Employee, on_delete="cascade")
    date = pw.DateField()
    day = pw.CharField()
    time = pw.TimeField()
    type = pw.IntegerField()


def t_1():
    cursor = db.execute_sql(" \
        SELECT DISTINCT e.e_name FROM employee e JOIN entries en ON e.id=en.id \
        WHERE en.date = '2018-12-14' AND en.type = 1 AND DATE_PART('minute', en.time::TIME - '9:00'::TIME) < 5; \
    ")

    for row in cursor.fetchall():
        print(row)
    
    cursor = Employee.select(Employee.e_name).join(Entries, on=(Employee.id == Entries.id)).where(
        Entries.date == "2018-12-14",
        Entries.type == 1,
        pw.fn.Date_part('minute', Entries.time.cast("time") - Cast("9:00", "time"))
    )  
    for row in cursor:
        print(row)

def task_2():
    cursor = db.execute_sql("SELECT DISTINCT e.e_name FROM employee e JOIN entries en ON e.id = en.id \
        WHERE en.date = '2018-12-14' AND en.type = 2 AND en.time - LAG(en.time) OVER (PARTITION BY en.time) > 10;")
    for row in cursor.fetchall():
        print(row)

    cursor = Employee.select(Employee.e_name).join(Entries, on=(Employee.id == Entries.id)).where(
        Entries.date == "2018-12-14",
        Entries.type == 2,
        Entries.time - pw.fn.Lag(Entries.time).over(partition_by=[Entries.time])
    )
    for row in cursor:
        print(row)

def t_3():
    cursor = db.execute_sql(" SELECT DISTINCT e.e_name, e.department FROM employee e JOIN entries en on e.id=en.id \
        WHERE e.department = 'Бухгалтерия' AND en.type = 1 AND en.time < '8:00'::TIME;")
    for row in cursor.fetchall():
        print(row)
    cursor = Employee.select(Employee.e_name, Employee.department).join(Entries, on=(Employee.id == Entries.id)).where(
        Employee.department == "Бухгалтерия",
        Entries.type == 1,
        Entries.time < Cast("8:00", "time")
    )
    for row in cursor:
        print(row)

def main():
    task_3()


if __name__ == "__main__":
    main()
