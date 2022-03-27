import pandas as pd

def f_read_excel(path, sheet_name):
    df = pd.read_excel(path, sheet_name=sheet_name)
    return df

if __name__ == '__main__':
    path = '../data/FR_Telkomsel.xlsx'
    sheet_name = 0
    df = f_read_excel(path, sheet_name)
    print (df)