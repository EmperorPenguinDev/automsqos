import pandas as pd
import numpy as np
import glob
import os
from functools import reduce
from funcs.parsing import f_parsing,f_parsing2
from funcs.parsing import f_groupby
from funcs.read_sql import f_read_sql


if __name__ == '__main__':
    pd.set_option('display.max_columns', 500)
    pd.set_option('display.width', 1000)
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
        # print(globals()[variable_name_all].columns)

    print(ftp_raw)
    # df = [ftp_raw,browsing_raw,capacity_raw,ping_raw,video_stream_raw,whatsapp_msg_raw,sms_onnet_raw,sms_offnet_raw,speech_quality_analitik_raw,apps_test_statisik_raw,video_attempt_raw]
    # df = [ping_raw,whatsapp_msg_raw]
    # df_compile = reduce(lambda left,right: pd.merge(left,right,on='SessionId'), df)
    # df = ping_raw.join(whatsapp_msg_raw.set_index('SessionId'), on='SessionId', lsuffix='_caller', rsuffix='_other')
    # print(df)