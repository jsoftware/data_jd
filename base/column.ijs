NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
coclass 'jdcolumn'

throw=: 13!:8&101 NB. jd not in our path

NB. There are 3 col types: static, dynamic, and summary (which may be killed off)

CLASS=: <'jdcolumn'
CHILD=: a:

STATE=: <;._2 ]0 : 0
typ
shape
)

NB. map as required
open=: 3 : 0
Cloc=: '_',(>LOCALE),'_'
coinserttofront 'jdt',typ
NB. writestate''
)

close=: 3 : 'unmapcolfile"0 MAP'

NB. y is typ;shape
testcreate=: 4 : 0
'typ shape' =: y
if. (t=.<'jdt',typ) -.@e. conl 0 do. throw 'Invalid column type: ',typ end.
x testcreate__t shape
)

create=: 3 : 0
'typ shape' =: y
open''
makecolfiles ''

NB. record column names in order of creation
if. -.'jd'-:2{.NAME do.
 f=. PATH__PARENT,'column_create_order.txt'
 t=. NAME,' '
 if. fexist f do.
  t fappend f
 else.
  t fwrite f
 end.
end. 
)

NB. refcount problems
NB. multiple processes mapping same file have problems with refcount
NB. normal mapping jams refcount to 2 - perhaps wrong for the other task
NB. unmapping reduces refcount to 1 - unmap in another task crashes on 4!:55 erase
NB. try using sharename to avoid these problems
NB. sharename causes jamming refcount high
NB. this means we miss detection (unmap result 2) of oprhans
NB. also refcount is added so it generally climbs which is not good
NB. could jam sharename to avoid some of these problems
NB. db lock enforces only 1 task mapping so these issues can be ignored

mapcolfile=: 3 : 0
jdmap (,&Cloc ; PATH&,) >y
)

unmapcolfile=: 3 : 0
jdunmap (>y),Cloc
)

NB. x is (type;shape), y is the name of the file
makecolfile=: 4 : 0
typ=.<'jdt',typ  [  'typ shape' =. x
r=. ROWSMIN>.Tlen
jdcreatejmf (PATH,y);r*DATASIZE__typ**/shape
jdmap (y,Cloc);PATH,y
if. 0=nc<'DATACOL_jd_' do.
 (y)=: DATACOL_jd_
 erase 'DATACOL_jd_'
else.
 (y) =: (($,)~ Tlen,shape,$@]) DATAFILL__typ
end. 
)

NB. resize single mapped name
resizemap=: 3 : 0
'name size' =. y
t=. (name,Cloc);size
'resizemap'logtxt NAME__PARENT,' ',NAME
jdunmap (name,Cloc);size
mapcolfile name
)

NB. resize file if required - flag 1 for replace
resize_if=: 3 : 0
'name data flag'=. y
if. flag do. old=. 0 else. old=. getbytes name~ end.
new=. getbytes data
if. (old+new)>getmsize_jmf_ name,Cloc do.
 if. (<name)e.;:'datr val nub' do.
  b=. >.1.5*old+new  NB.! how big should these guys be?
 elseif. 1 do.
  b=. (getbytes{.data)*ROWSMIN>.>.ROWSMULT*ROWSXTRA+(#name~)+#data
 end.
 resizemap name;b
end.
)

appendmap=: 4 : 0
resize_if x;y;0
". 'name=:name,y' rplc 'name';x
EMPTY NB. result
)

replacemap=: 4 : 0
name=. x
data=. y
while. 1 do.
 try.
  (name)=: data
  break.
 catch. NB. not catchd. as this error is expected and required
  assert 32=13!:11'' NB. allocation error
  resizemap name;>.Padvar*fsize PATH,name
 end.
end.
EMPTY NB. result
)

replacemap=: 4 : 0
resize_if x;y;1
name=. x
(name)=: y
EMPTY NB. result
)



getbytes=: 3 : 0
((JTYPES i. 3!:0 y){JSIZES)**/$y
)

NB. y is dat val hash link etc
NB. return msize rows (how many rows will fit in msize) 
getmsr=: 3 : 0
r=. getmsize_jmf_ y,Cloc
select. y 
case. 'dat' do.
 if. 'varbyte'-:typ do.
  a=. 8[s=. 2
 else.
  a=. DATASIZE [ s=. shape
 end. 
case. 'val' do.
 a=. 1
 s=. ''
case. do.
 a=. 8
 s=. ''
end. 
<.r%a**/s
)


NB. Export column to boxes
ExportMap=: 3 :'MAP ,&.> <Cloc'
Export=: [: ".&.> [: ". 'MAP'"_
NB. ExportRows=: (({&.:>{.),}.@]) Export

NB. ExportRows above has 2 nasty varbyte bugs
NB.  returned ptr to val (increase ref count)
NB.   if a resize was required this prevented unmap/remap
NB.   resulting in damaged table
NB.  entire val was appended to val so size doubled with update

NB. ExportRows below is a brute force fix to the above problems
NB.  rather than export efficient internal varbyte format
NB.  it exports list of boxes

NB. conversion of varbyte external <-> internal should be done in C
ExportRows=: 3 : 0
if. typ-:'varbyte' do.
 ,<select y
else. 
 y (({&.:>{.),}.@]) Export''
end. 
)

NB. x is flag,rows - flag 1 for modify
NB. y is data
NB. returns rows (used by insert_
validate_data=: 4 : 0
'modify rows'=. x
v=. y
'FECOL_jd_ FETYP_jd_ FESHAPE_jd_'=: NAME;typ;":shape
if. 'edate'-:5{.typ do.
 if. JCHAR=3!:0 v do. v=. efs v end. 
 select. typ
case. 'edate' do.
  EPRECISION assert *./(0=(86400*1e9)|v)+._9223372036854775808=v
 case. 'edatetime' do.
  EPRECISION assert *./(0=1e9|v)+._9223372036854775808=v
 case. 'edatetimem' do.
  EPRECISION assert *./(0=1e6|v)+._9223372036854775808=v
 end.
end.  

if. -.modify do.
 if. rows=_1 do. rows=. #v end.
 ETALLY assert rows=#v
end. 

tsv=. #sv=. $v
if. tsv<#1,shape do. tsv=. #sv=. rows,sv end.
ETALLY assert (1={.sv)+.rows={.sv
if. -.sv-:rows,shape do. NB. not exact - see if {. for byte fixes - overtake allowed - undertake not allowed
 ESHAPE assert -.''-:shape
 ESHAPE assert (JCHAR=3!:0 v)*.((}:sv)-:}:rows,shape)*.({:sv)<:shape
end.
vt=. 3!:0 v
select. typ
case. 'boolean' do.
 ETYPE assert vt=JB01
case. 'float'   do.
 ETYPE assert vt e. JFL,JINT,JB01
case. ;:'byte enum' do.
 ETYPE assert vt=JCHAR
case. 'varbyte' do.
 NB. if. modify do.
 NB.  ETYPE assert 0
 NB. else.
  ETYPE assert (vt=JBOXED)+.*/JCHAR=;3!:0 each v
 NB. end.
case.           do.
 ETYPE assert vt e. JINT,JB01
end.

rows NB. result used by insert
)
