import pandas as pd
import glob
import os
from funcs.parsing import f_parsing,f_parsing2
from funcs.parsing import f_groupby
from funcs.read_sql import f_read_sql

if __name__ == '__main__':
    pd.set_option('display.max_columns', 500)
    pd.set_option('display.width', 1000)
    # Connection to the database
    driver = "{SQL Server}"
    server = "10.31.0.23,1433"
    database = "ZONA11_JAKARTA_PUSAT_DT"
    username = "ms_reporting"
    password = "Kominfo@2021"

    # Variable all none
    Capacity_DL_all = None
    Capacity_UL_all = None
    FTP_DL_all = None
    HTTP_Browser_all = None
    RSCP_ECLO_all = None
    RSRP_RSRQ_all = None
    RxLvl_RxQual_all = None

    # Variable bad none
    Capacity_DL_bad = None
    Capacity_UL_bad = None
    FTP_DL_bad = None
    HTTP_Browser_bad = None
    RSCP_ECLO_bad = None
    RSRP_RSRQ_bad = None
    RxLvl_RxQual_bad = None

    # Read SQL files
    all_files = glob.glob("funcs/sql/query_fr/*.sql")
    for filename in all_files:
        head_tail = os.path.split(filename)
        f = open(filename, 'r')
        query = f.read()
        f.close()

        variable_name_all = head_tail[1][:-4]+"_all"
        globals()[variable_name_all] = f_read_sql(query, driver, server, database, username, password)
        # print(variable_name_all)
        # print(globals()[variable_name_all].dtypes)

    # If dataframe is empty pass, else parsing
    if RSRP_RSRQ_all.empty:
        pass
    else:
        RSRP_all = f_parsing(RSRP_RSRQ_all, 'RSRP', 'Kurang', -110, "<-110 dbm", "yes")
        RSRQ_all = f_parsing(RSRP_RSRQ_all, 'RSRQ', 'Kurang', -16, "<-16 dbm", "yes")
        RSRP_bad = f_parsing(RSRP_RSRQ_all, 'RSRP', 'Kurang', -110, "<-110 dbm", "no")
        RSRQ_bad = f_parsing(RSRP_RSRQ_all, 'RSRQ', 'Kurang', -16, "<-16 dbm", "no")
    if RSCP_ECLO_all.empty:
        pass
    else:
        RSCP_all = f_parsing(RSCP_ECLO_all, 'AvgRSCP', 'Kurang', -105, "<-105 dbm", "yes")
        ECLO_all = f_parsing(RSCP_ECLO_all, 'AvgEcIo', 'Kurang', -16, "<-16 dbm", "yes")
        RSCP_bad = f_parsing(RSCP_ECLO_all, 'AvgRSCP', 'Kurang', -105, "<-105 dbm", "no")
        ECLO_bad = f_parsing(RSCP_ECLO_all, 'AvgEcIo', 'Kurang', -16, "<-16 dbm", "no")
    if RxLvl_RxQual_all.empty:
        pass
    else:
        RxLvl_all = f_parsing(RxLvl_RxQual_all, 'RxLev', 'Kurang', -102, "<-102 dbm", "yes")
        RxQual_all = f_parsing2(RxLvl_RxQual_all, 'RxQual', 'Kurang', 6, 7, "6 dbm to 7 dbm", "yes")
        RxLvl_bad = f_parsing(RxLvl_RxQual_all, 'RxLev', 'Kurang', -102, "<-102 dbm", "no")
        RxQual_bad = f_parsing2(RxLvl_RxQual_all, 'RxQual', 'Kurang', 6, 7, "6 dbm to 7 dbm", "no")
    if FTP_DL_all.empty:
        pass
    else:
        FTP_DL_all = f_parsing(FTP_DL_all, 'Throughput', 'Kurang', 1000, "<1000", "yes")
        FTP_DL_bad = f_parsing(FTP_DL_all, 'Throughput', 'Kurang', 1000, "<1000", "no")
    if Capacity_DL_all.empty:
        pass
    else:
        Capacity_DL_all = f_parsing(Capacity_DL_all, 'DLThrpt', 'Kurang', 1000, "<1000", "yes")
        Capacity_DL_bad = f_parsing(Capacity_DL_all, 'DLThrpt', 'Kurang', 1000, "<1000", "no")
    if Capacity_UL_all.empty:
        pass
    else:
        Capacity_UL_all = f_parsing(Capacity_UL_all, 'ULThrpt', 'Kurang', 1000, "<1000", "yes")
        Capacity_UL_bad = f_parsing(Capacity_UL_all, 'ULThrpt', 'Kurang', 1000, "<1000", "no")
    if HTTP_Browser_all.empty:
        pass
    else:
        HTTP_Browser_all = f_parsing(HTTP_Browser_all, 'Throughput', 'Kurang', 1000, "<1000", "yes")
        HTTP_Browser_bad = f_parsing(HTTP_Browser_all, 'Throughput', 'Kurang', 1000, "<1000", "no")

    # Groupby bad
    try:
        Capacity_DL_bad_telkomsel = f_groupby(Capacity_DL_bad, 'Operator', 'Telkomsel')
    except:
        Capacity_DL_bad_telkomsel = pd.DataFrame()
    try:
        Capacity_UL_bad_telkomsel = f_groupby(Capacity_UL_bad, 'Operator', 'Telkomsel')
    except:
        Capacity_UL_bad_telkomsel = pd.DataFrame()
    try:
        FTP_DL_bad_telkomsel = f_groupby(FTP_DL_bad, 'Operator', 'Telkomsel')
    except:
        FTP_DL_bad_telkomsel = pd.DataFrame()
    try:
        HTTP_Browser_bad_telkomsel = f_groupby(HTTP_Browser_bad, 'Operator', 'Telkomsel')
    except:
        HTTP_Browser_bad_telkomsel = pd.DataFrame()
    try:
        RSCP_bad_telkomsel = f_groupby(RSCP_bad, 'Operator', 'Telkomsel')
    except:
        RSCP_bad_telkomsel = pd.DataFrame()
    try:
        ECLO_bad_telkomsel = f_groupby(ECLO_bad, 'Operator', 'Telkomsel')
    except:
        ECLO_bad_telkomsel = pd.DataFrame()
    try:
        RSRP_bad_telkomsel = f_groupby(RSRP_bad, 'Operator', 'Telkomsel')
    except:
        RSRP_bad_telkomsel = pd.DataFrame()
    try:
        RSRQ_bad_telkomsel = f_groupby(RSRQ_bad, 'Operator', 'Telkomsel')
    except:
        RSRQ_bad_telkomsel = pd.DataFrame()
    try:
        RxLvl_bad_telkomsel = f_groupby(RxLvl_bad, 'Operator', 'Telkomsel')
    except:
        RxLvl_bad_telkomsel = pd.DataFrame()
    try:
        RxQual_bad_telkomsel = f_groupby(RxQual_bad, 'Operator', 'Telkomsel')
    except:
        RxQual_bad_telkomsel = pd.DataFrame()

    try:
        Capacity_DL_bad_xl = f_groupby(Capacity_DL_bad, 'Operator', 'XL')
    except:
        Capacity_DL_bad_xl = pd.DataFrame()
    try:
        Capacity_UL_bad_xl = f_groupby(Capacity_UL_bad, 'Operator', 'XL')
    except:
        Capacity_UL_bad_xl = pd.DataFrame()
    try:
        FTP_DL_bad_xl = f_groupby(FTP_DL_bad, 'Operator', 'XL')
    except:
        FTP_DL_bad_xl = pd.DataFrame()
    try:
        HTTP_Browser_bad_xl = f_groupby(HTTP_Browser_bad, 'Operator', 'XL')
    except:
        HTTP_Browser_bad_xl = pd.DataFrame()
    try:
        RSCP_bad_xl = f_groupby(RSCP_bad, 'Operator', 'XL')
    except:
        RSCP_bad_xl = pd.DataFrame()
    try:
        ECLO_bad_xl = f_groupby(ECLO_bad, 'Operator', 'XL')
    except:
        ECLO_bad_xl = pd.DataFrame()
    try:
        RSRP_bad_xl = f_groupby(RSRP_bad, 'Operator', 'XL')
    except:
        RSRP_bad_xl = pd.DataFrame()
    try:
        RSRQ_bad_xl = f_groupby(RSRQ_bad, 'Operator', 'XL')
    except:
        RSRQ_bad_xl = pd.DataFrame()
    try:
        RxLvl_bad_xl = f_groupby(RxLvl_bad, 'Operator', 'XL')
    except:
        RxLvl_bad_xl = pd.DataFrame()
    try:
        RxQual_bad_xl = f_groupby(RxQual_bad, 'Operator', 'XL')
    except:
        RxQual_bad_xl = pd.DataFrame()

    try:
        Capacity_DL_bad_smartfren = f_groupby(Capacity_DL_bad, 'Operator', 'Smartfren')
    except:
        Capacity_DL_bad_smartfren = pd.DataFrame()
    try:
        Capacity_UL_bad_smartfren = f_groupby(Capacity_UL_bad, 'Operator', 'Smartfren')
    except:
        Capacity_UL_bad_smartfren = pd.DataFrame()
    try:
        FTP_DL_bad_smartfren = f_groupby(FTP_DL_bad, 'Operator', 'Smartfren')
    except:
        FTP_DL_bad_smartfren = pd.DataFrame()
    try:
        HTTP_Browser_bad_smartfren = f_groupby(HTTP_Browser_bad, 'Operator', 'Smartfren')
    except:
        HTTP_Browser_bad_smartfren = pd.DataFrame()
    try:
        RSCP_bad_smartfren = f_groupby(RSCP_bad, 'Operator', 'Smartfren')
    except:
        RSCP_bad_smartfren = pd.DataFrame()
    try:
        ECLO_bad_smartfren = f_groupby(ECLO_bad, 'Operator', 'Smartfren')
    except:
        ECLO_bad_smartfren = pd.DataFrame()
    try:
        RSRP_bad_smartfren = f_groupby(RSRP_bad, 'Operator', 'Smartfren')
    except:
        RSRP_bad_smartfren = pd.DataFrame()
    try:
        RSRQ_bad_smartfren = f_groupby(RSRQ_bad, 'Operator', 'Smartfren')
    except:
        RSRQ_bad_smartfren = pd.DataFrame()
    try:
        RxLvl_bad_smartfren = f_groupby(RxLvl_bad, 'Operator', 'Smartfren')
    except:
        RxLvl_bad_smartfren = pd.DataFrame()
    try:
        RxQual_bad_smartfren = f_groupby(RxQual_bad, 'Operator', 'Smartfren')
    except:
        RxQual_bad_smartfren = pd.DataFrame()

    try:
        Capacity_DL_bad_indosat = f_groupby(Capacity_DL_bad, 'Operator', 'Indosat Ooredoo')
    except:
        Capacity_DL_bad_indosat = pd.DataFrame()
    try:
        Capacity_UL_bad_indosat = f_groupby(Capacity_UL_bad, 'Operator', 'Indosat Ooredoo')
    except:
        Capacity_UL_bad_indosat = pd.DataFrame()
    try:
        FTP_DL_bad_indosat = f_groupby(FTP_DL_bad, 'Operator', 'Indosat Ooredoo')
    except:
        FTP_DL_bad_indosat = pd.DataFrame()
    try:
        HTTP_Browser_bad_indosat = f_groupby(HTTP_Browser_bad, 'Operator', 'Indosat Ooredoo')
    except:
        HTTP_Browser_bad_indosat = pd.DataFrame()
    try:
        RSCP_bad_indosat = f_groupby(RSCP_bad, 'Operator', 'Indosat Ooredoo')
    except:
        RSCP_bad_indosat = pd.DataFrame()
    try:
        ECLO_bad_indosat = f_groupby(ECLO_bad, 'Operator', 'Indosat Ooredoo')
    except:
        ECLO_bad_indosat = pd.DataFrame()
    try:
        RSRP_bad_indosat = f_groupby(RSRP_bad, 'Operator', 'Indosat Ooredoo')
    except:
        RSRP_bad_indosat = pd.DataFrame()
    try:
        RSRQ_bad_indosat = f_groupby(RSRQ_bad, 'Operator', 'Indosat Ooredoo')
    except:
        RSRQ_bad_indosat = pd.DataFrame()
    try:
        RxLvl_bad_indosat = f_groupby(RxLvl_bad, 'Operator', 'Indosat Ooredoo')
    except:
        RxLvl_bad_indosat = pd.DataFrame()
    try:
        RxQual_bad_indosat = f_groupby(RxQual_bad, 'Operator', 'Indosat Ooredoo')
    except:
        RxQual_bad_indosat = pd.DataFrame()

    try:
        Capacity_DL_bad_tri = f_groupby(Capacity_DL_bad, 'Operator', '3')
    except:
        Capacity_DL_bad_tri = pd.DataFrame()
    try:
        Capacity_UL_bad_tri = f_groupby(Capacity_UL_bad, 'Operator', '3')
    except:
        Capacity_UL_bad_tri = pd.DataFrame()
    try:
        FTP_DL_bad_tri = f_groupby(FTP_DL_bad, 'Operator', '3')
    except:
        FTP_DL_bad_tri = pd.DataFrame()
    try:
        HTTP_Browser_bad_tri = f_groupby(HTTP_Browser_bad, 'Operator', '3')
    except:
        HTTP_Browser_bad_tri = pd.DataFrame()
    try:
        RSCP_bad_tri = f_groupby(RSCP_bad, 'Operator', '3')
    except:
        RSCP_bad_tri = pd.DataFrame()
    try:
        ECLO_bad_tri = f_groupby(ECLO_bad, 'Operator', '3')
    except:
        ECLO_bad_tri = pd.DataFrame()
    try:
        RSRP_bad_tri = f_groupby(RSRP_bad, 'Operator', '3')
    except:
        RSRP_bad_tri = pd.DataFrame()
    try:
        RSRQ_bad_tri = f_groupby(RSRQ_bad, 'Operator', '3')
    except:
        RSRQ_bad_tri = pd.DataFrame()
    try:
        RxLvl_bad_tri = f_groupby(RxLvl_bad, 'Operator', '3')
    except:
        RxLvl_bad_tri = pd.DataFrame()
    try:
        RxQual_bad_tri = f_groupby(RxQual_bad, 'Operator', '3')
    except:
        RxQual_bad_tri = pd.DataFrame()

    # Groupby all
    try:
        Capacity_DL_all_telkomsel = f_groupby(Capacity_DL_all, 'Operator', 'Telkomsel')
    except:
        Capacity_DL_all_telkomsel = pd.DataFrame()
    try:
        Capacity_UL_all_telkomsel = f_groupby(Capacity_UL_all, 'Operator', 'Telkomsel')
    except:
        Capacity_UL_all_telkomsel = pd.DataFrame()
    try:
        FTP_DL_all_telkomsel = f_groupby(FTP_DL_all, 'Operator', 'Telkomsel')
    except:
        FTP_DL_all_telkomsel = pd.DataFrame()
    try:
        HTTP_Browser_all_telkomsel = f_groupby(HTTP_Browser_all, 'Operator', 'Telkomsel')
    except:
        HTTP_Browser_all_telkomsel = pd.DataFrame()
    try:
        RSCP_all_telkomsel = f_groupby(RSCP_all, 'Operator', 'Telkomsel')
    except:
        RSCP_all_telkomsel = pd.DataFrame()
    try:
        ECLO_all_telkomsel = f_groupby(ECLO_all, 'Operator', 'Telkomsel')
    except:
        ECLO_all_telkomsel = pd.DataFrame()
    try:
        RSRP_all_telkomsel = f_groupby(RSRP_all, 'Operator', 'Telkomsel')
    except:
        RSRP_all_telkomsel = pd.DataFrame()
    try:
        RSRQ_all_telkomsel = f_groupby(RSRQ_all, 'Operator', 'Telkomsel')
    except:
        RSRQ_all_telkomsel = pd.DataFrame()
    try:
        RxLvl_all_telkomsel = f_groupby(RxLvl_all, 'Operator', 'Telkomsel')
    except:
        RxLvl_all_telkomsel = pd.DataFrame()
    try:
        RxQual_all_telkomsel = f_groupby(RxQual_all, 'Operator', 'Telkomsel')
    except:
        RxQual_all_telkomsel = pd.DataFrame()

    try:
        Capacity_DL_all_xl = f_groupby(Capacity_DL_all, 'Operator', 'XL')
    except:
        Capacity_DL_all_xl = pd.DataFrame()
    try:
        Capacity_UL_all_xl = f_groupby(Capacity_UL_all, 'Operator', 'XL')
    except:
        Capacity_UL_all_xl = pd.DataFrame()
    try:
        FTP_DL_all_xl = f_groupby(FTP_DL_all, 'Operator', 'XL')
    except:
        FTP_DL_all_xl = pd.DataFrame()
    try:
        HTTP_Browser_all_xl = f_groupby(HTTP_Browser_all, 'Operator', 'XL')
    except:
        HTTP_Browser_all_xl = pd.DataFrame()
    try:
        RSCP_all_xl = f_groupby(RSCP_all, 'Operator', 'XL')
    except:
        RSCP_all_xl = pd.DataFrame()
    try:
        ECLO_all_xl = f_groupby(ECLO_all, 'Operator', 'XL')
    except:
        ECLO_all_xl = pd.DataFrame()
    try:
        RSRP_all_xl = f_groupby(RSRP_all, 'Operator', 'XL')
    except:
        RSRP_all_xl = pd.DataFrame()
    try:
        RSRQ_all_xl = f_groupby(RSRQ_all, 'Operator', 'XL')
    except:
        RSRQ_all_xl = pd.DataFrame()
    try:
        RxLvl_all_xl = f_groupby(RxLvl_all, 'Operator', 'XL')
    except:
        RxLvl_all_xl = pd.DataFrame()
    try:
        RxQual_all_xl = f_groupby(RxQual_all, 'Operator', 'XL')
    except:
        RxQual_all_xl = pd.DataFrame()

    try:
        Capacity_DL_all_smartfren = f_groupby(Capacity_DL_all, 'Operator', 'Smartfren')
    except:
        Capacity_DL_all_smartfren = pd.DataFrame()
    try:
        Capacity_UL_all_smartfren = f_groupby(Capacity_UL_all, 'Operator', 'Smartfren')
    except:
        Capacity_UL_all_smartfren = pd.DataFrame()
    try:
        FTP_DL_all_smartfren = f_groupby(FTP_DL_all, 'Operator', 'Smartfren')
    except:
        FTP_DL_all_smartfren = pd.DataFrame()
    try:
        HTTP_Browser_all_smartfren = f_groupby(HTTP_Browser_all, 'Operator', 'Smartfren')
    except:
        HTTP_Browser_all_smartfren = pd.DataFrame()
    try:
        RSCP_all_smartfren = f_groupby(RSCP_all, 'Operator', 'Smartfren')
    except:
        RSCP_all_smartfren = pd.DataFrame()
    try:
        ECLO_all_smartfren = f_groupby(ECLO_all, 'Operator', 'Smartfren')
    except:
        ECLO_all_smartfren = pd.DataFrame()
    try:
        RSRP_all_smartfren = f_groupby(RSRP_all, 'Operator', 'Smartfren')
    except:
        RSRP_all_smartfren = pd.DataFrame()
    try:
        RSRQ_all_smartfren = f_groupby(RSRQ_all, 'Operator', 'Smartfren')
    except:
        RSRQ_all_smartfren = pd.DataFrame()
    try:
        RxLvl_all_smartfren = f_groupby(RxLvl_all, 'Operator', 'Smartfren')
    except:
        RxLvl_all_smartfren = pd.DataFrame()
    try:
        RxQual_all_smartfren = f_groupby(RxQual_all, 'Operator', 'Smartfren')
    except:
        RxQual_all_smartfren = pd.DataFrame()

    try:
        Capacity_DL_all_indosat = f_groupby(Capacity_DL_all, 'Operator', 'Indosat Ooredoo')
    except:
        Capacity_DL_all_indosat = pd.DataFrame()
    try:
        Capacity_UL_all_indosat = f_groupby(Capacity_UL_all, 'Operator', 'Indosat Ooredoo')
    except:
        Capacity_UL_all_indosat = pd.DataFrame()
    try:
        FTP_DL_all_indosat = f_groupby(FTP_DL_all, 'Operator', 'Indosat Ooredoo')
    except:
        FTP_DL_all_indosat = pd.DataFrame()
    try:
        HTTP_Browser_all_indosat = f_groupby(HTTP_Browser_all, 'Operator', 'Indosat Ooredoo')
    except:
        HTTP_Browser_all_indosat = pd.DataFrame()
    try:
        RSCP_all_indosat = f_groupby(RSCP_all, 'Operator', 'Indosat Ooredoo')
    except:
        RSCP_all_indosat = pd.DataFrame()
    try:
        ECLO_all_indosat = f_groupby(ECLO_all, 'Operator', 'Indosat Ooredoo')
    except:
        ECLO_all_indosat = pd.DataFrame()
    try:
        RSRP_all_indosat = f_groupby(RSRP_all, 'Operator', 'Indosat Ooredoo')
    except:
        RSRP_all_indosat = pd.DataFrame()
    try:
        RSRQ_all_indosat = f_groupby(RSRQ_all, 'Operator', 'Indosat Ooredoo')
    except:
        RSRQ_all_indosat = pd.DataFrame()
    try:
        RxLvl_all_indosat = f_groupby(RxLvl_all, 'Operator', 'Indosat Ooredoo')
    except:
        RxLvl_all_indosat = pd.DataFrame()
    try:
        RxQual_all_indosat = f_groupby(RxQual_all, 'Operator', 'Indosat Ooredoo')
    except:
        RxQual_all_indosat = pd.DataFrame()

    try:
        Capacity_DL_all_tri = f_groupby(Capacity_DL_all, 'Operator', '3')
    except:
        Capacity_DL_all_tri = pd.DataFrame()
    try:
        Capacity_UL_all_tri = f_groupby(Capacity_UL_all, 'Operator', '3')
    except:
        Capacity_UL_all_tri = pd.DataFrame()
    try:
        FTP_DL_all_tri = f_groupby(FTP_DL_all, 'Operator', '3')
    except:
        FTP_DL_all_tri = pd.DataFrame()
    try:
        HTTP_Browser_all_tri = f_groupby(HTTP_Browser_all, 'Operator', '3')
    except:
        HTTP_Browser_all_tri = pd.DataFrame()
    try:
        RSCP_all_tri = f_groupby(RSCP_all, 'Operator', '3')
    except:
        RSCP_all_tri = pd.DataFrame()
    try:
        ECLO_all_tri = f_groupby(ECLO_all, 'Operator', '3')
    except:
        ECLO_all_tri = pd.DataFrame()
    try:
        RSRP_all_tri = f_groupby(RSRP_all, 'Operator', '3')
    except:
        RSRP_all_tri = pd.DataFrame()
    try:
        RSRQ_all_tri = f_groupby(RSRQ_all, 'Operator', '3')
    except:
        RSRQ_all_tri = pd.DataFrame()
    try:
        RxLvl_all_tri = f_groupby(RxLvl_all, 'Operator', '3')
    except:
        RxLvl_all_tri = pd.DataFrame()
    try:
        RxQual_all_tri = f_groupby(RxQual_all, 'Operator', '3')
    except:
        RxQual_all_tri = pd.DataFrame()

    # Create a Pandas Excel writer using XlsxWriter as the engine.
    fr_telkomsel_bad = pd.ExcelWriter('data/fr/parsed/bad/FR_Telkomsel.xlsx', engine='xlsxwriter')
    fr_xl_bad = pd.ExcelWriter('data/fr/parsed/bad/FR_XL.xlsx', engine='xlsxwriter')
    fr_smartfren_bad = pd.ExcelWriter('data/fr/parsed/bad/FR_Smartfren.xlsx', engine='xlsxwriter')
    fr_indosat_bad = pd.ExcelWriter('data/fr/parsed/bad/FR_Indosat.xlsx', engine='xlsxwriter')
    fr_tri_bad = pd.ExcelWriter('data/fr/parsed/bad/FR_3.xlsx', engine='xlsxwriter')

    # Create a Pandas Excel writer using XlsxWriter as the engine.
    fr_telkomsel_all = pd.ExcelWriter('data/fr/parsed/all/FR_Telkomsel.xlsx', engine='xlsxwriter')
    fr_xl_all = pd.ExcelWriter('data/fr/parsed/all/FR_XL.xlsx', engine='xlsxwriter')
    fr_smartfren_all = pd.ExcelWriter('data/fr/parsed/all/FR_Smartfren.xlsx', engine='xlsxwriter')
    fr_indosat_all = pd.ExcelWriter('data/fr/parsed/all/FR_Indosat.xlsx', engine='xlsxwriter')
    fr_tri_all = pd.ExcelWriter('data/fr/parsed/all/FR_3.xlsx', engine='xlsxwriter')

    # Write each dataframe bad to a different worksheet.
    RSRP_bad_telkomsel.to_excel(fr_telkomsel_bad, sheet_name='RSRP')
    RSRQ_bad_telkomsel.to_excel(fr_telkomsel_bad, sheet_name='RSRQ')
    RSCP_bad_telkomsel.to_excel(fr_telkomsel_bad, sheet_name='RSCP')
    ECLO_bad_telkomsel.to_excel(fr_telkomsel_bad, sheet_name='ECLO')
    RxLvl_bad_telkomsel.to_excel(fr_telkomsel_bad, sheet_name='RxLvl')
    RxQual_bad_telkomsel.to_excel(fr_telkomsel_bad, sheet_name='RxQual')
    FTP_DL_bad_telkomsel.to_excel(fr_telkomsel_bad, sheet_name='FTP_DL')
    Capacity_DL_bad_telkomsel.to_excel(fr_telkomsel_bad, sheet_name='Capacity_DL')
    Capacity_UL_bad_telkomsel.to_excel(fr_telkomsel_bad, sheet_name='Capacity_UL')
    HTTP_Browser_bad_telkomsel.to_excel(fr_telkomsel_bad, sheet_name='HTTP_Browser')

    RSRP_bad_xl.to_excel(fr_xl_bad, sheet_name='RSRP')
    RSRQ_bad_xl.to_excel(fr_xl_bad, sheet_name='RSRQ')
    RSCP_bad_xl.to_excel(fr_xl_bad, sheet_name='RSCP')
    ECLO_bad_xl.to_excel(fr_xl_bad, sheet_name='ECLO')
    RxLvl_bad_xl.to_excel(fr_xl_bad, sheet_name='RxLvl')
    RxQual_bad_xl.to_excel(fr_xl_bad, sheet_name='RxQual')
    FTP_DL_bad_xl.to_excel(fr_xl_bad, sheet_name='FTP_DL')
    Capacity_DL_bad_xl.to_excel(fr_xl_bad, sheet_name='Capacity_DL')
    Capacity_UL_bad_xl.to_excel(fr_xl_bad, sheet_name='Capacity_UL')
    HTTP_Browser_bad_xl.to_excel(fr_xl_bad, sheet_name='HTTP_Browser')

    RSRP_bad_smartfren.to_excel(fr_smartfren_bad, sheet_name='RSRP')
    RSRQ_bad_smartfren.to_excel(fr_smartfren_bad, sheet_name='RSRQ')
    RSCP_bad_smartfren.to_excel(fr_smartfren_bad, sheet_name='RSCP')
    ECLO_bad_smartfren.to_excel(fr_smartfren_bad, sheet_name='ECLO')
    RxLvl_bad_smartfren.to_excel(fr_smartfren_bad, sheet_name='RxLvl')
    RxQual_bad_smartfren.to_excel(fr_smartfren_bad, sheet_name='RxQual')
    FTP_DL_bad_smartfren.to_excel(fr_smartfren_bad, sheet_name='FTP_DL')
    Capacity_DL_bad_smartfren.to_excel(fr_smartfren_bad, sheet_name='Capacity_DL')
    Capacity_UL_bad_smartfren.to_excel(fr_smartfren_bad, sheet_name='Capacity_UL')
    HTTP_Browser_bad_smartfren.to_excel(fr_smartfren_bad, sheet_name='HTTP_Browser')

    RSRP_bad_indosat.to_excel(fr_indosat_bad, sheet_name='RSRP')
    RSRQ_bad_indosat.to_excel(fr_indosat_bad, sheet_name='RSRQ')
    RSCP_bad_indosat.to_excel(fr_indosat_bad, sheet_name='RSCP')
    ECLO_bad_indosat.to_excel(fr_indosat_bad, sheet_name='ECLO')
    RxLvl_bad_indosat.to_excel(fr_indosat_bad, sheet_name='RxLvl')
    RxQual_bad_indosat.to_excel(fr_indosat_bad, sheet_name='RxQual')
    FTP_DL_bad_indosat.to_excel(fr_indosat_bad, sheet_name='FTP_DL')
    Capacity_DL_bad_indosat.to_excel(fr_indosat_bad, sheet_name='Capacity_DL')
    Capacity_UL_bad_indosat.to_excel(fr_indosat_bad, sheet_name='Capacity_UL')
    HTTP_Browser_bad_indosat.to_excel(fr_indosat_bad, sheet_name='HTTP_Browser')

    RSRP_bad_tri.to_excel(fr_tri_bad, sheet_name='RSRP')
    RSRQ_bad_tri.to_excel(fr_tri_bad, sheet_name='RSRQ')
    RSCP_bad_tri.to_excel(fr_tri_bad, sheet_name='RSCP')
    ECLO_bad_tri.to_excel(fr_tri_bad, sheet_name='ECLO')
    RxLvl_bad_tri.to_excel(fr_tri_bad, sheet_name='RxLvl')
    RxQual_bad_tri.to_excel(fr_tri_bad, sheet_name='RxQual')
    FTP_DL_bad_tri.to_excel(fr_tri_bad, sheet_name='FTP_DL')
    Capacity_DL_bad_tri.to_excel(fr_tri_bad, sheet_name='Capacity_DL')
    Capacity_UL_bad_tri.to_excel(fr_tri_bad, sheet_name='Capacity_UL')
    HTTP_Browser_bad_tri.to_excel(fr_tri_bad, sheet_name='HTTP_Browser')

    # Write each dataframe all to a different worksheet.
    RSRP_all_telkomsel.to_excel(fr_telkomsel_all, sheet_name='RSRP')
    RSRQ_all_telkomsel.to_excel(fr_telkomsel_all, sheet_name='RSRQ')
    RSCP_all_telkomsel.to_excel(fr_telkomsel_all, sheet_name='RSCP')
    ECLO_all_telkomsel.to_excel(fr_telkomsel_all, sheet_name='ECLO')
    RxLvl_all_telkomsel.to_excel(fr_telkomsel_all, sheet_name='RxLvl')
    RxQual_all_telkomsel.to_excel(fr_telkomsel_all, sheet_name='RxQual')
    FTP_DL_all_telkomsel.to_excel(fr_telkomsel_all, sheet_name='FTP_DL')
    Capacity_DL_all_telkomsel.to_excel(fr_telkomsel_all, sheet_name='Capacity_DL')
    Capacity_UL_all_telkomsel.to_excel(fr_telkomsel_all, sheet_name='Capacity_UL')
    HTTP_Browser_all_telkomsel.to_excel(fr_telkomsel_all, sheet_name='HTTP_Browser')

    RSRP_all_xl.to_excel(fr_xl_all, sheet_name='RSRP')
    RSRQ_all_xl.to_excel(fr_xl_all, sheet_name='RSRQ')
    RSCP_all_xl.to_excel(fr_xl_all, sheet_name='RSCP')
    ECLO_all_xl.to_excel(fr_xl_all, sheet_name='ECLO')
    RxLvl_all_xl.to_excel(fr_xl_all, sheet_name='RxLvl')
    RxQual_all_xl.to_excel(fr_xl_all, sheet_name='RxQual')
    FTP_DL_all_xl.to_excel(fr_xl_all, sheet_name='FTP_DL')
    Capacity_DL_all_xl.to_excel(fr_xl_all, sheet_name='Capacity_DL')
    Capacity_UL_all_xl.to_excel(fr_xl_all, sheet_name='Capacity_UL')
    HTTP_Browser_all_xl.to_excel(fr_xl_all, sheet_name='HTTP_Browser')

    RSRP_all_smartfren.to_excel(fr_smartfren_all, sheet_name='RSRP')
    RSRQ_all_smartfren.to_excel(fr_smartfren_all, sheet_name='RSRQ')
    RSCP_all_smartfren.to_excel(fr_smartfren_all, sheet_name='RSCP')
    ECLO_all_smartfren.to_excel(fr_smartfren_all, sheet_name='ECLO')
    RxLvl_all_smartfren.to_excel(fr_smartfren_all, sheet_name='RxLvl')
    RxQual_all_smartfren.to_excel(fr_smartfren_all, sheet_name='RxQual')
    FTP_DL_all_smartfren.to_excel(fr_smartfren_all, sheet_name='FTP_DL')
    Capacity_DL_all_smartfren.to_excel(fr_smartfren_all, sheet_name='Capacity_DL')
    Capacity_UL_all_smartfren.to_excel(fr_smartfren_all, sheet_name='Capacity_UL')
    HTTP_Browser_all_smartfren.to_excel(fr_smartfren_all, sheet_name='HTTP_Browser')

    RSRP_all_indosat.to_excel(fr_indosat_all, sheet_name='RSRP')
    RSRQ_all_indosat.to_excel(fr_indosat_all, sheet_name='RSRQ')
    RSCP_all_indosat.to_excel(fr_indosat_all, sheet_name='RSCP')
    ECLO_all_indosat.to_excel(fr_indosat_all, sheet_name='ECLO')
    RxLvl_all_indosat.to_excel(fr_indosat_all, sheet_name='RxLvl')
    RxQual_all_indosat.to_excel(fr_indosat_all, sheet_name='RxQual')
    FTP_DL_all_indosat.to_excel(fr_indosat_all, sheet_name='FTP_DL')
    Capacity_DL_all_indosat.to_excel(fr_indosat_all, sheet_name='Capacity_DL')
    Capacity_UL_all_indosat.to_excel(fr_indosat_all, sheet_name='Capacity_UL')
    HTTP_Browser_all_indosat.to_excel(fr_indosat_all, sheet_name='HTTP_Browser')

    RSRP_all_tri.to_excel(fr_tri_all, sheet_name='RSRP')
    RSRQ_all_tri.to_excel(fr_tri_all, sheet_name='RSRQ')
    RSCP_all_tri.to_excel(fr_tri_all, sheet_name='RSCP')
    ECLO_all_tri.to_excel(fr_tri_all, sheet_name='ECLO')
    RxLvl_all_tri.to_excel(fr_tri_all, sheet_name='RxLvl')
    RxQual_all_tri.to_excel(fr_tri_all, sheet_name='RxQual')
    FTP_DL_all_tri.to_excel(fr_tri_all, sheet_name='FTP_DL')
    Capacity_DL_all_tri.to_excel(fr_tri_all, sheet_name='Capacity_DL')
    Capacity_UL_all_tri.to_excel(fr_tri_all, sheet_name='Capacity_UL')
    HTTP_Browser_all_tri.to_excel(fr_tri_all, sheet_name='HTTP_Browser')

    # Close the Pandas Excel writer and output the Excel file.
    fr_telkomsel_bad.save()
    fr_xl_bad.save()
    fr_smartfren_bad.save()
    fr_indosat_bad.save()
    fr_tri_bad.save()

    fr_telkomsel_all.save()
    fr_xl_all.save()
    fr_smartfren_all.save()
    fr_indosat_all.save()
    fr_tri_all.save()

    print("Finish")