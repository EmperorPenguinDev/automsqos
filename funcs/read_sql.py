import pyodbc
import pandas as pd
import urllib.parse
from sqlalchemy import create_engine

def f_read_sql(query):
    driver = "{SQL Server)"
    server = "10.31.0.23,1433"
    database = "ZONA03_KOTA_PADANG_P0I1"
    username = "ms_reporting"
    password = "Kominfo@2021"
    conn = pyodbc.connect("DRIVER="+driver+";SERVER="+server+";DATABASE="+database+";UID="+username+";PWD="+password)
    cursor = conn.cursor()
    for row in cursor.execute(query):
        print(row)

def f_read_sql2(query,server,database,username,password):
    connectString = 'Driver={ODBC Driver 17 for SQL Server};Server=localhost,1433;uid=SA;pwd=<YourNewStrong!Passw0rd>;Database=TestDB'
    url = urllib.parse.quote(connectString)
    engine = create_engine("mssql+pyodbc:///?odbc_connect=" + url)
    engine.execute('select * from Inventory').fetchall()

    # Solution B: Using Hostname Connections (not preferred - says the sqlalchemy doc)
    # --------------------------------------

    engine = create_engine(
        "mssql+pyodbc://SA:<YourNewStrong!Passw0rd>@localhost:1433/TestDB?driver=ODBC+Driver+17+for+SQL+Server")
    engine.execute('select * from Inventory').fetchall()

if __name__ == '__main__':
    query = "SELECT TOP 10 * FROM LTEMeasurementReport;"
    df = f_read_sql(query)
    print(df)