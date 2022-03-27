import sys
import numpy as np
import pandas as pd

def f_parsing(dfs, cols, cat, rangess):
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

if __name__ == '__main__':
    # test
    df = pd.read_csv('data/RSRP.csv',encoding='iso-8859-1', low_memory=False)
    df = f_parsing(df, 'RSRP', 'Kurang', -110)
    df.to_csv('data/RSRP_parsed.csv', index=False)
    print(df)