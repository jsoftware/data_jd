# write Jd table cols to csv/parquet/... file
import pandas as pd
import numpy as np
import sys
from numpy import fromfile

jmfheader= 568 # bytes at start of jmf file

# get col array of strings from file
def getcol(file,shape,cnt):
 r= []
 f= open(file,'rb')
 sk= jmfheader
 for i in range(cnt):
  f.seek(sk)
  b= f.read(int(shape))
  sk= sk+shape
  r.append(b.decode())
 return r

table= str(sys.argv[1])
op=    str(sys.argv[2])
cnt=   int(str(sys.argv[3]))

f= open(table+"/jd_pandas_write.txt", 'r')
s= f.read()
names= s.split('\n') # names[0] is colname type shape
df = pd.DataFrame()
for i,nm in enumerate(names):
 p= str(names[i])
 a= p.rsplit(' ',1)
 shape= str(a[1])
 b= a[0].rsplit(' ',1)
 type= str(b[1])
 colname= str(b[0])
 s= table+colname+"/dat"
 if type!='object':
  if type=='datetime64[ns]':
   a= fromfile(s, dtype=type, count=cnt, offset=jmfheader) 
   for i in range(cnt):
    if ~np.isnan(a[i]):
     a[i]= a[i]+946684800000000000 # adjust to epoch 1970
   df[colname]= a 
  else:
   df[colname]= fromfile(s, dtype=type, count=cnt, offset=jmfheader)
 else:
  shape= 1 if shape=='_' else int(shape)
  df[colname]= getcol(s,shape,cnt)

eval("df."+op)
