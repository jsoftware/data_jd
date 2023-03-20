# args "path-to-pandas-raw" "python-line-to-read-file"
import pandas as pd
import sys

sink=   str(sys.argv[1])
source= str(sys.argv[2])

jmfheader= 568 # bytes at start of jmf file

df= eval("pd."+source)
cols= df.columns
types= df.dtypes

for idx,col in enumerate(cols):
 print(str(idx).rjust(4,' ')+" "+col)
 # build meta data col+type+rows
 m= str(types[[col]])
 m= m.split('\n')[0]
 t= m.split(' ')[-1] # datatype
 m= t+'\t'+str(df.shape[0])
 
 n= str(idx).rjust(4,'0')
 f= open(sink+n+'.pandasmeta','w')
 f.write(col+"\t"+m+'\t')
 f.close()

 f= open(sink+n+'.dat','w')
 f.write(' '*jmfheader)
 if t=='object':
  df[col].fillna('\x00',inplace=True)   # NONE replaced by '\x00'
  df[col].astype('|S').values.tofile(f) # object assumed to be char (varchar)
 else:
  df[[col]].values.tofile(f)
 f.close()
