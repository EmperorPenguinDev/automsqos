import sys
import numpy as np
import pandas as pd
from pandas.api.types import is_string_dtype
from pandas.api.types import is_numeric_dtype

# function to replace NaN with a blank string
def f_replace_nan(df):
    dfs = df.fillna('')
    return dfs

# function to groupby one column
def f_groupby(df, cols, values):
    df = df[df[cols].isin([values])]
    df.reset_index(drop=True)
    return df

# function to aggregate columns
def f_aggregate(dfs, cols, agg):
    dfs = dfs.groupby(cols).agg({agg: ['mean', 'min', 'max']})
    dfs = dfs.reset_index()
    return dfs

# function to convert string to datetime
def f_string_to_datetime(dfs, cols):
    dfs[cols] = pd.to_datetime(dfs[cols])
    return dfs

# function to parse datetime to date
def f_datetime_to_date(dfs, cols):
    dfs[cols] = [d.date() for d in dfs[cols]]
    return dfs

# function to replace string with string
def f_replace_string(dfs, cols, old, new):
    dfs[cols] = dfs[cols].replace(old, new)
    return dfs

# function to parse data when hit the treshold
def f_parsing(dfs, cols, cat, ranges, rangess, show):
    dfs[cols] = dfs[cols].fillna(0)
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

# function to parse data when hit two treshold
def f_parsing2(dfs, cols, cat, ranges1, ranges2, rangess, show):
    dfs[cols] = dfs[cols].fillna(0)
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