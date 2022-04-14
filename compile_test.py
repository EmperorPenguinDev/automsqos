import pandas as pd
import numpy as np
import glob
import os
from functools import reduce
from funcs.parsing import *
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

    apps_test_statistic_raw = None
    browsing_raw = None
    capacity_raw = None
    ftp_raw = None
    ping_raw = None
    sms_offnet_raw = None
    sms_onnet_raw = None
    speech_quality_analytic_raw = None
    video_attempt_raw = None
    video_stream_raw = None
    whatsapp_msg_raw = None

    # Read SQL files
    all_files = glob.glob("data/compile/raw/*.csv")
    for filename in all_files:
        head_tail = os.path.split(filename)
        variable_name_all = head_tail[1][:-4]
        globals()[variable_name_all] = pd.read_csv(filename, sep=',', encoding='iso-8859-1', low_memory=False)
        # print(globals()[variable_name_all].columns)

    # clean data apps_test_statistic_raw
    # apps_test_statistic_raw = f_replace_nan(apps_test_statistic_raw)
    # apps_test_statistic_raw = f_string_to_datetime(apps_test_statistic_raw, 'msgDate')
    # apps_test_statistic_raw = f_datetime_to_date(apps_test_statistic_raw, 'msgDate')
    # apps_test_statistic_raw = f_string_to_datetime(apps_test_statistic_raw, 'msgDate')
    # apps_test_statistic_raw['msgDate'] = apps_test_statistic_raw['msgDate'].dt.strftime('%d.%m.%Y')
    # print(apps_test_statistic_raw)

    # FTP DL
    ftp_dl = f_groupby(ftp_raw, 'ket', 'GET')
    ftp_dl = f_aggregate(ftp_dl, ['msgDate', 'Home Operator', 'ket'], 'Throughput')
    print(ftp_dl)
    print(ftp_dl.dtypes)

    # FTP UL
    ftp_ul = f_groupby(ftp_raw, 'ket', 'PUT')
    ftp_ul = f_aggregate(ftp_ul, ['msgDate', 'Home Operator', 'ket'], 'Throughput')
    print(ftp_ul)
    print(ftp_ul.dtypes)

    # df = [ftp_raw,browsing_raw,capacity_raw,ping_raw,video_stream_raw,whatsapp_msg_raw,sms_onnet_raw,sms_offnet_raw,speech_quality_analytic_raw,apps_test_statistic_raw,video_attempt_raw]
    # df = [ping_raw,whatsapp_msg_raw]
    # df_compile = reduce(lambda left,right: pd.merge(left,right,on='SessionId'), df)
    # df = ping_raw.join(whatsapp_msg_raw.set_index('SessionId'), on='SessionId', lsuffix='_caller', rsuffix='_other')
    # print(df)