import pandas as pd
import sys

jmfheader= 568 # bytes at start of jmf file

def tobin(file, dfcol):
 if 'object'==str(dfcol.dtype):
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

def doit(sink,source,cnt):
 df= eval("pd."+source)

 if cnt != 'all':
  cnt= int(cnt)
  if cnt<0:
   df= df.tail(-cnt)
  else:  
   df= df.head(cnt)
 
 cols= df.columns
 types= df.dtypes

 for idx,col in enumerate(cols):
  print(str(idx).rjust(4,' ')+" "+str(col))
  # build meta data col+type+rows
  m= str(types[[col]])
  m= m.split('\n')[0]
  t= m.split(' ')[-1] # datatype
  m= t+'\t'+str(df.shape[0])
 
  n= str(idx).rjust(4,'0')
  f= open(sink+n+'.pandasmeta','w')
  f.write(str(col)+"\t"+m+'\t') # write metadata to pandasmeta file
  f.close()
 
  tobin(sink+n+'.dat',df[col]) # write data bytes to dat file
  
sink=   str(sys.argv[1]) # "j9.4-user/temp/jd/pandas_db/pandas_table/jdpandas_raw/"
source= str(sys.argv[2]) # "read_csv(\"t0.csv\")"
cnt=    str(sys.argv[3]) # "all"

doit(sink,source,cnt)

# debug
# >python3 -i .../addons/data/jd/tools/pandas/load.py
# >>> doit("tmp/","read_csv('t0.csv')","all")
