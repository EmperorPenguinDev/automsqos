from funcs.read_table import f_read_table
from funcs.read_sql import f_read_sql
from funcs.read_excel import f_read_excel
from funcs.insert_to_db import f_insert_to_db

if __name__ == '__main__':
    query = open('funcs/RSRP.sql', 'r')
    df = f_read_sql(query.read(), 'ZONA05_PASAMAN_BARAT_DT', 'ms_reporting', 'Kominfo@2021', '10.31.0.23', '1433')
    query.close()
    print(df)