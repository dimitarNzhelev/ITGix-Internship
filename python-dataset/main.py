import pandas as pd

table = pd.read_csv('./spotify.csv', encoding='unicode_escape')
print (table.head(7))
print (table.shape)
print(table.columns)