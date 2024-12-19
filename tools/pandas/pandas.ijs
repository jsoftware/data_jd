coclass'jd'

0 : 0
use python/pandas to:
 load parquet/feathers/orc/csv/... files into Jd tables
 and write Jd table to those formats

   jdrt'pandas_install'
   jdrt'pandas_load'
   jdrt'pandas_write'

Jd tables and pandas dataframes are surprisingly compatible

currently the following datetypes are handled
 Jd int   <> pandas int64
 Jd float <> pandas float64
 Jd byte  <> pandas array of strings
 these could be extended with more work
 
Jd bytes vs pandas strings
 if byte is utf-8 this works well, but there are edge conditions
 
Jd datetime epoch is 2000 - pandas is 1970
 this requires adjustment by efs_jd_'1970
 but do not adjust NaT/IMIN values!
 
missing (or bad) values are treated differently
 Jd missing:
  byte     - blanks
  int      - IMIN
  float    - __
  datetime - __
  any missing numeric has the min value for the type
 
 pandas missing:
  string   - None - marked as missing
  int64    - -. (column is converted to float64)
  float64  - -. Na
  datetime - -. NaT 
  
 loading from pandas
  replaces None with ({.a.),blank padding
  replaces -. with IMIN and coerces to int if possible
  
 writing to pandas
  does not adjust - but could be an option in the future
)


pandas_test=: 3 : 0
getjdfile        'yellow_tripdata.parquet'
f=. jpath'~temp/jdfiles/yellow_tripdata.parquet'
pandas_load_jd_  'pandas_db';'pandas_table';2;'read_parquet';f;''
jd'reads from pandas_table'
)

t=.  ;:'csv parquet feathers orc' NB. add others as appropriate
pandas_load_ops=: (<'read_'),each t
pandas_write_ops=: (<'to_'),each t

pandas_na=: 128!:5 NB. detect _. in float data

pandas_ptypes=: 'int64';'float64';'datetime64[ns]';'datetime64[us]';'object'
pandas_jtypes=: 'int'  ;'float'  ;'edatetimen'    ;'edatetimen'    ;'byte'

pandas_jtypes_from=: 3 : 0
i=. pandas_ptypes i. boxopen y
t=. ;' ',each~.(i=#pandas_ptypes)#y
('unsupported pandas type(s): ',t) assert 0=#t NB. should not happen
i{pandas_jtypes
)

NB. append to log file
pandas_log=: 3 : 0
'table txt'=. y
(txt,LF) fappend jdpath table,'/jd_pandas_log.txt'
)

NB. read log file
pandas_read_log=: 3 : 0
fread jdpath y,'/jd_pandas_log.txt'
)

NB. database ; table ; count ; op ; file ; parms
NB. database - jdadmin arg
NB. table    - Jd table to create from file
NB. count    - rows to load - 'all' for all or n for first n or _n last n
NB. op       - pandas op
NB. file     - file to load
NB. parms    - additional parameters to pandas op
pandas_load=: 3 : 0
'db table cnt op file parms'=. y
pandas_raw       y
pandas_createcol y   NB. create Jd table with raw pandas data
pandas_fix       y   NB. fix Na and edatetimen
pandas_log       table;LF,'*** finished'
i.0 0
)

NB. database;data_frame_source
NB. 'pandas';'csv_examples/yellow_tripdata_2022-01.parquet'
pandas_raw=: 3 : 0
'db table cnt op file parms'=. y
jdadmin :: ('new'&jdadmin) db
'not in set of allowed read ops'assert (<op)e.pandas_load_ops_jd_
'file does not exist'assert fexist file
jd'droptable ',table
jd'createtable ',table
pandas_log table;'*** pandas_raw  ',;' ',each ":each y
pandas_path=. jdpath_jd_ table,'/'
pandas_snk=. pandas_path,'jdpandas_raw/'

jddeletefolder_jd_ pandas_snk
jdcreatefolder_jd_ pandas_snk
NB.! pandas_log - noun noun!
f=. pandas_snk,'jnk.jmf'
createjmf_jmf_ f;0
pandas_jmf_header_template=: fread f
ferase f
py=. JDP,'tools/pandas/load.py'
fop=. op,'(',(dquotex jpath file),parms,')'
fop=. fop rplc '"';'\"'
q=. '"<py>" "<snk>" "<fop>" "<cnt>"' rplc '<py>';py;'<snk>';pandas_snk;'<fop>';fop;'<cnt>';(":cnt)rplc'_';'-'
f=. jdpath '/jd_pandas_python.txt' NB. stdout/stderr redirect
f python_run q

if. -.fexist pandas_snk,'0000.pandasmeta' do.
 echo q
 echo fread f
 'python_run failed'assert 0
end. 

pandas_log table;LF,'   python load.py stdout/stderr',LF,fread f
i.0 0
)

pandas_createcol=: 3 : 0
'db table cnt op file parms'=. y
pandas_log table;LF,'*** pandas_createcol'
jd'close'
pandas_path=. jdpath_jd_ table,'/'
pandas_snk=. pandas_path,'jdpandas_raw/'
ps=. _4}.each /:~{."1 dirtree pandas_path,'*.dat'
'no pandas dat files'assert 0~:#ps
md=. <;._2 each fread each ps,each<'.pandasmeta'
types=. >1{each md

NB. remove cols from ps that have unsupported type
i=. pandas_ptypes i. types
b=. i~:#pandas_jtypes
if. +/0=b do.
 pandas_log table;'col(s) with unsupported types will be left in:',LF,pandas_snk
 for_d. (-.b)#md do.
  pandas_log table;'unsupported type',;' ',each >d
 end.
end. 
ps=. b#ps
md=. <;._2 each fread each ps,each<'.pandasmeta'
types=. >1{each md

names=. >0{each md
rows=.  ;0".each >2{each md
vcname_jd_ each names
jtypes=. pandas_jtypes_from types
tlen=. ~.rows
'cols have different rows'assert 1=#tlen

for_p. ps do. pandas_jmf ;p end. NB. fix jmf header in each pandas dat file

jdadmin pandas_db
for_p. ps do.
 p=. ;p
 'name type rows'=. <;._2 fread p,'.pandasmeta'
 t=. ;pandas_jtypes_from <type
 if. 'object'-:type do.
  d=. fsize p,'.dat'
  c=. (d-HS_jmf_)%0".rows
  t=. t,' ',":;(1=c){c;''
 end.
 jd'createcol ',table,' ',(dquotex name),' ',t
end.

c=. jdgl_jd_ table
Tlen__c=: tlen

pt=. PATH__c
jd'close' NB. not really necessary???

NB. move pandas cols to table cols
for_i. i.#ps do.
 fraw=. (;i{ps),'.dat'
 fdat=. pt,(dfromn i{::names),'/dat'
 ferase fdat NB. windows frename requires that target does not exist
 fdat frename fraw
 (fread (;i{ps),'.pandasmeta')fwrite pt,(dfromn i{::names),'/pandasmeta'
 ferase (;i{ps),'.pandasmeta'
end.
NB. jddeletefolder pandas_snk NB. should be empty 

i.0 0
)

NB. panda_jmf path-to-folder-with-pandasmeta - called by pandas_load
pandas_jmf=: 3 : 0
pf=. y
meta=. fread pf,'.pandasmeta'
'name type rows'=. <;._2 meta
rows=. 0".rows
i=. pandas_ptypes i.<type
jt=. i{4 8 4 4 2
size=. (fsize pf,'.dat')-HS_jmf_

n=. pandas_jmf_header_template
n=. (3 ic rows) (HADS_jmf_+i.8)}n
n=. (3 ic jt)   (HADT_jmf_+i.8)}n
n=. (3 ic size) (HADM_jmf_+i.8)}n
n=. (3 ic rows) (HADN_jmf_+i.8)}n NB. count

NB. object->char needs rank 2 and shape and count of rows*cols
if. 'object'-:type do.
 cols=. <.size%rows
 if. cols>1 do.
  n=. (3 ic rows*cols) (HADN_jmf_+i.8)}n NB. count
  n=. (3 ic cols) (HADS_jmf_+8+i.8)}n
  n=. (1 ic 2)    (HADRUS_jmf_+i.2)}n NB. assumes newheader and jams rank 2
 end. 
end. 
f=. 1!:21 <hostpathsep jpath pf,'.dat'
n fwrite f;0
1!:22 f
i.0 0
)

NB. fix Jd table cols
NB. pandas Na values replaced by J na values
NB. float that is all int (no fractional part) is coerced to int
NB. pandas edatetime adjusted for differnt epoch base (1970->2000)
NB.  kludge to avoid adjusting epoch again on 2nd run
pandas_fix=: 3 : 0
'db table cnt op file parms'=. y
pandas_log table;LF,'*** pandas_fix'
cols=. dltb each<"1 >1{"1 {:jd'info schema ',table
nmax=. >./;#each cols
for_n. cols do.
 n=. ;n
 repn=. nmax{.n
 c=. jdgl_jd_ table,' ',dquotex n
 select. typ__c
 case. 'float' do.
  nas=. pandas_na dat__c
  nac=. +/nas
  nasI=. I.nas
  if. 0~:nac do. 
   dat__c=: 0 nasI}dat__c    NB. replace nas with 0
   q=. +/0=1|!.0 dat__c      NB. count integers
   if. q=#dat__c do.
    pandas_log table;repn,' has Na count of: ',(":nac),' - coerced to int'
    q=. <.forcecopy dat__c
    q=. IMIN_jd_ nasI}q
    typ__c=: 'int'
    writestate__c'' NB. so typ persists!
    had=. memhad_jmf_ 'dat_',(;c),'_'
    JINT_jmf_ memw had,HADT_jmf_,1,JINT NB. set jmf header type to int
    dat__c=: q
   else. 
    pandas_log table;repn,' has Na count of: ',":nac
    dat__c=: __ nasI}dat__c NB. J na value
   end. 
  end.
 case. 'edatetimen' do.
  NB. adjust for epoch since 1970 vs 2000 and [us] millis vs nanos
  if. _1=nc <'pandas_fix_has_been_run__c' do.
   NB. pandas NaT is IMIN - do NOT adjust it
   pt=. ;1{<;._2 fread PATH__c,'pandasmeta'
   pandas_log table;repn,' ',pt,' adjusted'
   select. pt
   case. 'datetime64[ns]' do.
    dat__c=: dat__c+(dat__c~:IMIN)*efs_jd_'1970'
   case. 'datetime64[us]' do.
    b=. dat__c~:IMIN
    dat__c=: (dat__c*b{1,1000)+b*efs_jd_'1970'
   case. do.
    pandas_log table;repn,' ',pt,' NOT adjusted'
   end.  
  end.
  pandas_fix_has_been_run__c=: 1
 end.
end.
i.0 0
)

pandas_write_set_arg=: 3 : 0
'cols types shapes'=.   <"1 each 1 2 3{{:jd'info schema ',y
cols=. dtb each cols
types=. dtb each types

i=. pandas_jtypes i. types
types=. i{pandas_ptypes NB. error here is unsupported type

NB. types=. types,each ":each shapes-.each<_
NB. types=. (<'S1') ((types=<,'S')#i.#types)}types

r=. cols,each ' ',each types,each' ',each (":each shapes),each LF

bad=. types=<'unsupported'
if. +/bad do.
 echo'following have unsupported type - and will not be written'
 echo >bad#r
 r=. (-.bad)#r
end.
(}:;r) fwrite f=. (jdpath y),'/jd_pandas_write.txt'
)

NB. database ; table ; count ; op ; file ; parms
NB. database - jdadmin arg
NB. table    - Jd table to write to file
NB. count    - rows to write - 'all' for all rows
NB. op       - pandas op
NB. file     - file to write
NB. parms    - parameters to pandas op
pandas_write=: 3 : 0
'db table cnt op file parms'=. y
jdadmin db
rows=. ,>{:{:jd'info summary ',table
if. cnt-:'all' do. cnt=. rows end.
cnt=. ":cnt<.rows
'not in set of allowed write ops'assert (<op)e.pandas_write_ops_jd_
pandas_write_set_arg table
py=. JDP,'tools/pandas/write.py'
src=. jdpath_jd_ table,'/'
fop=. op,'(',(dquotex jpath file),parms,')'
fop=. fop rplc '"';'\"'
q=. '"<py>" "<src>" "<fop>" "<cnt>"' rplc '<py>';py;'<src>';src;'<fop>';fop;'<cnt>';cnt
f=. jpath '~temp/jd_pandas_output.txt' NB. stdout/stderr redirect

ferase file NB. rid of file we are creating
f python_run q
if. -.fexist file do.
 echo q
 echo fread f
 'python_run failed'assert 0
end. 
fread f
)

NB. python stuff

pysub=: 3 : 0
shell_jtask_  :: 'failed' python3_bin,y
)

pystatus=: 3 : 0
f=. '~config/python3.cfg'
python3_bin=: fread f 
if. _1=python3_bin do.
 python3_bin=: ;IFUNIX{'py';'python3'
 echo 'setting ~config/python3.cfg to: ',python3_bin
 python3_bin fwrite f
end.

python3=. pysub' --version'
'python3 binary not found'assert -.python3-:'failed' 

pip3=. shell_jtask_  :: 'failed' 'pip3 --version'
'pip3 binary not found'assert -.pip3-:'failed'

pandas=. pysub' -c "import pandas as p;print(p.__version__)"'
if. pandas-:'failed' do.
 echo'installing pandas'
 echo shell_jtask_'pip3 install pandas'
 pandas=. pysub,' -c "import pandas as p;print(p.__version__)"'
 'pandas install failed'assert -.pandas-:'failed'
end. 

pyarrow=. pysub' -c "import pyarrow as p;print(p.__version__)"'
if. pyarrow-:'failed' do.
 echo'installing pyarrow'
 echo shell_jtask_'pip3 install pyarrow'
 pyarrow=. pysub' -c "import pyarrow as p;print(p.__version__)"'
 'pyarrow install failed'assert -.pyarrow-:'failed'
end.

r=. 0 2$''
r=. r,'~config/python.cfg';python3_bin
r=. r,'python3';python3
r=. r,'pip3';pip3
r=. r,'pandas';pandas
r=. r,'pyarrow';pyarrow
)

NB. y python command - x stdout/stderr redirect file
python_run=: 3 : 0
'~temp/jd_pandas_output.txt'python_run y
:
t=. python3_bin,' ',y,' 1> "<out>" 2>&1'rplc'<out>';jpath x
try. shell t
catch.
 NB. windows shell does not signal error!
 echo 'python_run failed'
end.
fread x
)

3 : 0''
python3_bin=: fread '~config/python3.cfg'
if. python3_bin-:_1 do. pystatus'' end.
)
