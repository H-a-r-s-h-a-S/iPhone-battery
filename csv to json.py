import json
import pandas as pd

data = pd.read_csv('final.csv', names=['battery start', 'battery end', 'charge start', 'charge end', 'timezone', 'rn1', 'rn2'])
data = data.to_dict(orient="records")

with open('final.json','w') as f:
    print(*data,sep='\n', file=f)

with open('final.json', 'r') as f:
    final = f.read()

with open('final.json', 'w') as f:
    print(final.replace("'", '"'), file=f)
