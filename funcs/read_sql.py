import pyodbc
import pandas as pd
import urllib.parse
from sqlalchemy import create_engine

def f_read_sql(query,driver,server,database,username,password):
    conn = pyodbc.connect("DRIVER="+driver+";SERVER="+server+";DATABASE="+database+";UID="+username+";PWD="+password)
    df = pd.read_sql_query(query, conn)
    conn.close()
    return df

if __name__ == '__main__':
    driver = "{SQL Server}"
    server = "10.31.0.23,1433"
    database = "ZONA07_KOTA_DUMAI_DT"
    username = "ms_reporting"
    password = "Kominfo@2021"

    f = open('funcs/sql/RSRP.sql','r')
    query = f.read()
    f.close()
    df = f_read_sql(query,driver,server,database,username,password)
    print(df)