import sys
import numpy as np
import pandas as pd

def f_parsing(dfs, cols, cat, ranges, rangess, show):
    dfs[cols] = dfs[cols].astype('float')
    if show == "yes":
        b = []
        for i, d in dfs.iterrows():
            if d[cols] < ranges:
                d['Cat'] = cat
                d['Range'] = rangess
                b.append(d)
            else:
                d['Cat'] = ""
                d['Range'] = ""
                b.append(d)            
        df = pd.DataFrame(b)
        df = df.replace(np.nan, "")
        df.reset_index(drop=True)
        return df
    elif show == "no":
        b = []
        for i, d in dfs.iterrows():
            if d[cols] < ranges:
                d['Cat'] = cat
                d['Range'] = rangess
                b.append(d)
            else:
                pass            
        df = pd.DataFrame(b)
        df = df.replace(np.nan, "")
        df.reset_index(drop=True)
        return df

def f_parsing2(dfs, cols, cat, ranges1, ranges2, rangess, show):
    dfs[cols] = dfs[cols].astype('float32')
    if show == "yes":
        b = []
        for i, d in dfs.iterrows():
            if ranges1 <= d[cols] <= ranges2:
                d['Cat'] = cat
                d['Range'] = rangess
                b.append(d)
            else:
                d['Cat'] = ""
                d['Range'] = ""
                b.append(d)
        df = pd.DataFrame(b)
        df = df.replace(np.nan, "")
        df.reset_index(drop=True)
        return df
    elif show == "no":
        b = []
        for i, d in dfs.iterrows():
            if ranges1 <= d[cols] <= ranges2:
                d['Cat'] = cat
                d['Range'] = rangess
                b.append(d)
            else:
                pass
        df = pd.DataFrame(b)
        df = df.replace(np.nan, "")
        df.reset_index(drop=True)
        return df

# create a function to groupby one column
def f_groupby(df, cols, values):
    df = df[df[cols].isin([values])]
    df.reset_index(drop=True)
    return df

if __name__ == '__main__':
    # test
    df = pd.read_csv('data/raw/RSRP.csv',encoding='iso-8859-1', low_memory=False)
    df = f_parsing(df, 'RSRP', 'Kurang', -110, "<-110 dbm", "yes")
    df_telkomsel = f_groupby(df, 'Operator', 'Telkomsel')
    df_xl = f_groupby(df, 'Operator', 'XL')
    df_smartfren = f_groupby(df, 'Operator', 'Smartfren')
    df_indosat= f_groupby(df, 'Operator', 'Indosat Ooredoo')
    df_telkomsel.to_excel('data/parsed/all/FR_Telkomsel.xlsx', index=False, sheet_name='RSRP')
    df_xl.to_excel('data/parsed/all/FR_XL.xlsx', index=False, sheet_name='RSRP')
    df_smartfren.to_excel('data/parsed/all/FR_Smartfren.xlsx', index=False, sheet_name='RSRP')
    df_indosat.to_excel('data/parsed/all/FR_Indosat.xlsx', index=False, sheet_name='RSRP')

    print(df)