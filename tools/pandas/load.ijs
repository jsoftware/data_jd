coclass'jd'

0 : 0
load parquet/feathers/orc/... files into Jd

   jdrt'parquet'

issues:
 blanks in file name?
 J na value for bytes?
 NA in numeric data
 NAT?

 pandas datetime[ns] is ns since 1970 - Jd is since 2000
  adjust pandas col by efs_jd_'1970'  

 any Na values promotes pandas col to float
  coerce to int if possible with JNa

 a col char is treated as Jd list
)

pandas_test=: 3 : 0
getjdfile        'yellow_tripdata.parquet'
src=. pandas_src 'parquet';'~temp/jdfiles/yellow_tripdata.parquet'
pandas_load      'pandas';pandas_parquet_template rplc '<f>';jpath '~temp/jdfiles/yellow_tripdata.parquet'
)

NB. return python pandas dataframe read command for: file-type;file-name
pandas_src=: 3 : 0
't f'=. y
('pandas_',t,'_template')~ rplc '<f>';jpath f
)

pandas_parquet_template=:  'read_parquet(\"<f>\")'
pandas_feathers_template=: 'read_feathers(\"<f>\")'
pandas_orc_template=:      'read_orc(\"<f>\")'

pandas_na=: 128!:5 NB. detect _. in float data

pandas_ptypes=: 'int64';'float64';'datetime64[ns]';'object'
pandas_jtypes=: 'int'  ;'float'  ;'edatetimen'    ;'byte'

pandas_jtypes_from=: 3 : 0
i=. pandas_ptypes i. boxopen y
'unsupported pandas type' assert i<#pandas_ptypes
i{pandas_jtypes
)

pandas_table=: 'pandas_table' NB. global that ties routines to work on same table

NB. append to log file
pandas_log=: 3 : 0
(y,LF) fappend jdpath pandas_table,'/jd_pandas_log.txt'
)

NB. read log file
pandas_read_log=: 3 : 0
fread jdpath pandas_table,'/jd_pandas_log.txt'
)

NB. 'pandas';src
pandas_load=: 3 : 0
pandas_raw       y
pandas_createcol '' NB. create Jd table with raw pandas data
pandas_fix       '' NB. fix Na and edatetimen
pandas_log       LF,'*** finished'
i.0 0
)

NB. database;data_frame_source
NB. 'pandas';'csv_examples/yellow_tripdata_2022-01.parquet'
pandas_raw=: 3 : 0
'pandas_db pandas_src'=. y
jdadmin :: ('new'&jdadmin) pandas_db
jd'droptable ',pandas_table
jd'createtable ',pandas_table
pandas_log '*** pandas_raw  ',}:;' ',each y
pandas_path=. jdpath_jd_ pandas_table,'/'
pandas_snk=. pandas_path,'jdpandas_raw/'

jddeletefolder_jd_ pandas_snk
jdcreatefolder_jd_ pandas_snk

f=. pandas_snk,'jnk.jmf'
createjmf_jmf_ f;0
pandas_jmf_header_template=: fread f
ferase f

py=. JDP,'tools/pandas/load.py'
q=. '"<py>" "<snk>" "<src>"' rplc '<py>';py;'<snk>';pandas_snk;'<src>';pandas_src
f=. jdpath '/jd_pandas_python.txt' NB. stdout/stderr redirect
f python_run q
pandas_log LF,'   python load.py stdout/stderr',LF,fread f
i.0 0
)

pandas_createcol=: 3 : 0
pandas_log LF,'*** pandas_createcol'
jd'close'
pandas_path=. jdpath_jd_ pandas_table,'/'
pandas_snk=. pandas_path,'jdpandas_raw/'
ps=. _4}.each /:~{."1 dirtree pandas_path,'*.dat'
'no pandas dat files'assert 0~:#ps
md=. <;._2 each fread each ps,each<'.pandasmeta'
names=. >0{each md
types=. >1{each md
rows=.  ;0".each >2{each md
vcname_jd_ each names
jtypes=. pandas_jtypes_from types
tlen=. ~.rows
'cols have different rows'assert 1=#tlen

for_p. ps do. pandas_jmf ;p end. NB. fix jmf header in each panda dat file

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
 jd'createcol ',pandas_table,' ',name,' ',t
end.
c=. jdgl_jd_ pandas_table
Tlen__c=: tlen
pt=. PATH__c
jd'close' NB. not really necessary???

NB. move pandas cols to table cols
for_i. i.#ps do.
 (pt,(i{::names),'/dat') frename (;i{ps),'.dat'
 ferase (;i{ps),'.pandasmeta'
end.
jddeletefolder pandas_snk NB. should be empty 
i.0 0
)

NB. panda_jmf path-to-folder-with-pandasmeta - called by pandas_load
pandas_jmf=: 3 : 0
pf=. y
meta=. fread pf,'.pandasmeta'
'name type rows'=. <;._2 meta
rows=. 0".rows

i=. ('int64';'float64';'datetime64[ns]';'object')i.<type
jt=. i{4 8 4 2
size=. (fsize pf,'.dat')-HS_jmf_

n=. pandas_jmf_header_template
n=. (3 ic rows) (HADS_jmf_+i.8)}n
n=. (3 ic jt)   (HADT_jmf_+i.8)}n
n=. (3 ic size) (HADM_jmf_+i.8)}n
n=. (3 ic rows) (HADN_jmf_+i.8)}n NB. count

NB. object->char needs rank 2 and shape
if. 'object'-:type do.
 cols=. <.size%rows
 if. cols>1 do.
  n=. (3 ic cols) (HADS_jmf_+8+i.8)}n
  n=. (1 ic 2)    (HADRUS_jmf_+i.2)}n NB. assumes newheader and jams rank 2
 end. 
end. 

f=. 1!:21 <jpath pf,'.dat'
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
pandas_log LF,'*** pandas_fix'
cols=. dltb each<"1 >1{"1 {:jd'info schema ',pandas_table
nmax=. >./;#each cols
for_n. cols do.
 n=. ;n
 repn=. nmax{.n
 c=. jdgl_jd_ pandas_table,' ',n
 select. typ__c
 case. 'float' do.
  nas=. pandas_na dat__c
  nac=. +/nas
  nasI=. I.nas
  if. 0~:nac do. 
   dat__c=: 0 nasI}dat__c    NB. replace nas with 0
   q=. +/0=1|!.0 dat__c      NB. count integers
   if. q=#dat__c do.
    pandas_log repn,' has Na count of: ',(":nac),' - coerced to int'
    q=. <.forcecopy dat__c
    q=. IMIN_jd_ nasI}q
    typ__c=: 'int'
    had=. memhad_jmf_ 'dat_',(;c),'_'
    JINT_jmf_ memw had,HADT_jmf_,1,JINT NB. set jmf header type to int
    dat__c=: q
   else. 
    pandas_log repn,' has Na count of: ',":nac
    dat__c=: __ nasI}dat__c NB. J na value
   end. 
  end.
 case. 'edatetimen' do.
  if. _1=nc <'pandas_fix_has_been_run__c' do.
   pandas_log repn,' adjusted for epoch since 1970 vs 2000'
   dat__c=: dat__c+efs_jd_'1970'
   pandas_fix_has_been_run__c=: 1
  end. 
 end.
end.
i.0 0
)

NB. python stuff

python_bin=: 'python3'

NB. y python command
NB. x stdout/stderr redirect file
python_run=: 4 : 0
t=. python_bin,' ',y,' 1> "<out>" 2>&1'rplc'<out>';jpath x
try. shell t catch. 'python command failed'assert 0[echo fread x end.
fread x