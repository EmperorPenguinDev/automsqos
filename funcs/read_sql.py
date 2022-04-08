import pyodbc
import pandas as pd
import urllib.parse
from sqlalchemy import create_engine

def f_read_sql(query,driver,server,database,username,password):
    conn = pyodbc.connect("DRIVER="+driver+";SERVER="+server+";DATABASE="+database+";UID="+username+";PWD="+password)
    df = pd.read_sql_query(query, conn)
    df = pd.DataFrame(df)

    conn.close()
    return df

if __name__ == '__main__':
    pd.set_option('display.max_columns', 500)
    pd.set_option('display.width', 1000)

    driver = "{SQL Server}"
    server = "10.31.0.23,1433"
    database = "ZONA11_JAKARTA_TIMUR_DT"
    username = "ms_reporting"
    password = "Kominfo@2021"

    f = open('C:/Work/automsqos/funcs/sql/query_fr/Capacity_UL.sql','r')
    query = f.read()
    f.close()
    df = f_read_sql(query,driver,server,database,username,password)
    print(df.dtypes)
    print(df)