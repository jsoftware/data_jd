NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdcolumn'

throw=: 13!:8&101 NB. jd not in our path

NB. There are 3 col types: static, dynamic, and summary (which may be killed off)

CLASS=: <'jdcolumn'
CHILD=: a:

STATE=: <;._2 ]0 : 0
typ
shape
)

NB. =========================================================
init=: 3 : 0
Cloc=: '_',(>LOCALE),'_'
coinserttofront 'jdt',typ
NB. writestate''
)

NB. map as required - except for a few cases where all are mapped up front
open=: 3 : 0
init ''
if. -.APIRULES do.
 mapcolfile"0 MAP
 opentyp ''
end.
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
init ''
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
NB. this means we miss detection (unmap result 2) of oprhan references
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
r=. getallocr''
jdcreatejmf (PATH,y);r*DATASIZE__typ**/shape
jdmap (y,Cloc);PATH,y
if. 0=nc<'DATACOL_jd_' do.
 (y)=: DATACOL_jd_
 erase 'DATACOL_jd_'
else.
 (y) =: (($,)~ Tlen,shape,$@]) DATAFILL__typ
end. 
)

NB. map datr - sized to match other table
makecolfile_datr=: 3 : 0
typ=.<'jdt',typ  [  'typ shape' =. ('index';$0)
r=. getallocr__y''
jdcreatejmf (PATH,'datr');r*DATASIZE__typ**/shape
jdmap ('datr',Cloc);PATH,'datr'
NB.! datr=: (($,)~ Tlen__y,shape,$@]) DATAFILL__typ
)

NB. resize single mapped name
resizemap=: 3 : 0
'name size' =. y
t=. (name,Cloc);size
'resizemap'trace t
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
NB.  returned reference to val (increase ref count)
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

NB. =========================================================
NB. Dependency handling
getdeps =: 3 : 0
c =. getloc__PARENT&>&.> {:"1 SUBSCR
cc =. 3 : 'if. 0=4!:0<''ADOPTEDBY__y'' do. getloc__PARENT__y ADOPTEDBY__y else. y end.'"0&.> c
(getloc__PARENT@> {."1 SUBSCR) #~ +./@:e.&LOCALE&> cc
)
NB. Return a list of (child,parent) pairs
getalldeps =: 3 : 0
if. 0=#deps=.getdeps'' do. 0 2$a: return. end.
(LOCALE&,"0 , 3 :'getalldeps__y $0'(<@)"0(;@:))^:(*@#) deps
)
