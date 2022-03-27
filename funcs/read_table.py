import pandas as pd
from sqlalchemy import create_engine

def f_read_table(table_name, db_name, db_user, db_pass, db_host, db_port):
    DATABASES = {
        'production':{
            'NAME': db_name,
            'USER': db_user,
            'PASSWORD': db_pass,
            'HOST': db_host,
            'PORT': db_port,
        },
    }

    # choose the database to use
    db = DATABASES['production']

    # construct an engine connection string
    engine_string = "postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}".format(
        user = db['USER'],
        password = db['PASSWORD'],
        host = db['HOST'],
        port = db['PORT'],
        database = db['NAME'],
    )

    # create sqlalchemy engine
    engine = create_engine(engine_string)

    # read a table from database into pandas dataframe, replace "tablename" with your table name
    df = pd.read_sql_table(table_name,engine)

    return df

if __name__ == '__main__':
    df = f_read_table('tablename', 'database_name', 'username', 'password', 'host', 'port')
    print(df)