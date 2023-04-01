# exec(open('git/addons/data/jd/tools/pandas/util.py').read())

import pandas as pd
import sys

jmfheader= 568 # bytes at start of jmf file

def bld(file):
 df= pd.read_csv(file)
 return df
 
def tobin(file, dfcol):
 if 'object'==str(dfcol.dtype):
  print('object')
  dfcol.fillna('\x00',inplace=True)   # NONE replaced by '\x00'
  f= open(file,'wb')
  f.write(b' '*jmfheader)
  n= 0
  for c in dfcol: # get max byte length
   n= max(n,len(c.encode()))
  for c in dfcol:
   f.write(c.encode().ljust(n))
  f.close()
 else:
  f= open(file,'w')
  f.write(' '*jmfheader)
  dfcol.values.tofile(f)
  f.close()


def get(file,shape,cnt):
 r= []
 f= open(file,'rb')
 sk= jmfheader
 for i in range(cnt):
  f.seek(sk)
  b= f.read(int(shape))
  sk= sk+shape
  r.append(b.decode())
 return r
  