import sys
import numpy as np
import pandas as pd

def f_parsing(dfs, cols, cat, rangess, show):
    if show == "yes":
        b = []
        for i, d in dfs.iterrows():
            if d[cols] < rangess:
                d['Cat'] = cat
                d['Range'] = "<-110 dBm"
                b.append(d)
            else:
                d['Cat'] = ""
                d['Range'] = ""
                b.append(d)            
        df = pd.DataFrame(b)
        df = df.replace(np.nan, "")
        return df
    elif show == "no":
        b = []
        for i, d in dfs.iterrows():
            if d[cols] < rangess:
                d['Cat'] = cat
                d['Range'] = "<-110 dBm"
                b.append(d)
            else:
                pass            
        df = pd.DataFrame(b)
        df = df.replace(np.nan, "")
        return df
# create a function to groupby one column
def f_groupby(df, cols, operator):
    df = df[df[cols].isin([operator])]
    return df

if __name__ == '__main__':
    # test
    df = pd.read_csv('data/raw/RSRP.csv',encoding='iso-8859-1', low_memory=False)
    df = f_parsing(df, 'RSRP', 'Kurang', -110, "no")    
    df_telkomsel = f_groupby(df, 'Operator', 'Telkomsel')
    df_xl = f_groupby(df, 'Operator', 'XL')
    df_smartfren = f_groupby(df, 'Operator', 'Smartfren')
    df_indosat= f_groupby(df, 'Operator', 'Indosat Ooredoo')
    df_telkomsel.to_excel('data/parsed/bad/FR_Telkomsel.xlsx', index=False, sheet_name='RSRP')
    df_xl.to_excel('data/parsed/bad/FR_XL.xlsx', index=False, sheet_name='RSRP')
    df_smartfren.to_excel('data/parsed/bad/FR_Smartfren.xlsx', index=False, sheet_name='RSRP')
    df_indosat.to_excel('data/parsed/bad/FR_Indosat.xlsx', index=False, sheet_name='RSRP')

    print(df)