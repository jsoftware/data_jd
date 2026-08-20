NB. python stuff

coclass'jd'

pysub=: 3 : 0
shell_jtask_  :: 'failed' python3_bin,' ',y
)

NB. ~config/python3.cfg used as path to python binary
NB. verify python, pandas, and pyarrow
pystatus=: 3 : 0
f=. '~config/python3.cfg'
if. -.fexist f do. '' fwrite f end.
python3_bin=: CRLF-.~dltb fread f 
if. 0=#python3_bin do.
 echo f,' is empty'
 if. IFWIN do.
  python3_bin=: 'py'
 else.
  python3_bin=: 'python3'
  t=. 1 1 dir'~/.venvs/'
  for_n. t do.
   if. fexist (;n),'bin/python3' do.
    python3_bin=: (;n),'bin/python3'
    break.
   end. 
  end.
 end.
 echo f,' set as ',python3_bin   
 python3_bin fwrite f
end. 

python3=. pysub'--version'
('python3 binary ',python3_bin,' not found')assert -.python3-:'failed' 

pandas=. pysub'-c "import pandas as p;print(p.__version__)"'
'python pandas module not found'assert-.pandas-:'failed'

pyarrow=. pysub'-c "import pyarrow as p;print(p.__version__)"'
'python pyarrow module not found'assert-.pyarrow-:'failed'

r=. 0 2$''
r=. r,'~config/python3.cfg';python3_bin
r=. r,'python3';python3
r=. r,'pandas';pandas
r=. r,'pyarrow';pyarrow
)
