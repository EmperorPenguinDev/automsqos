import pandas as pd
import glob
import os
from funcs.parsing import f_parsing,f_parsing2
from funcs.parsing import f_groupby
from funcs.read_sql import f_read_sql

if __name__ == '__main__':
    # Connection to the database
    driver = "{SQL Server}"
    server = "10.31.0.23,1433"
    database = "ZONA11_JAKARTA_TIMUR_DT"
    username = "ms_reporting"
    password = "Kominfo@2021"

    apps_test_statisik_raw = None
    browsing_raw = None
    capacity_raw = None
    ftp_raw = None
    ping_raw = None
    sms_offnet_raw = None
    sms_onnet_raw = None
    speech_quality_analitik_raw = None
    video_attempt_raw = None
    video_stream_raw = None
    whatsapp_msg_raw = None

    # Read SQL files
    all_files = glob.glob("funcs/sql/query_compile/*.sql")
    for filename in all_files:
        head_tail = os.path.split(filename)
        f = open(filename, 'r')
        query = f.read()
        f.close()

        variable_name_all = head_tail[1][:-4]
        globals()[variable_name_all] = f_read_sql(query, driver, server, database, username, password)

    print(whatsapp_msg_raw)