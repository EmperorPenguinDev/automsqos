import pandas as pd
from sqlalchemy import create_engine
import sys
from pandas.io import sql
import sqlalchemy

def f_insert_to_db(df,engine,table,schema):
    # df = pd.read_csv(df, encoding='iso-8859-1', low_memory=False)
    engine = create_engine(engine)
    df.to_sql(table, con=engine,schema=schema,index=False,if_exists='append')
    return df

if __name__ == "__main__" :
    pd.set_option('max_columns', 100)
    pd.set_option('display.width', 1000)

    path = sys.argv[1]

    df = pd.read_csv(path,encoding='iso-8859-1', low_memory=False)
    print(df)
    # insert = f_insert_to_db(df,'postgresql://postgres:Immsp4102@10.1.10.26:5432/sabit_db','test','testing')
    print("Done Insert")