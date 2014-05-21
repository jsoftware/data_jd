NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
coclass 'jdcolumn'

NB. There are 3 col types: static, dynamic, and summary (which may be killed off)

CLASS=: <'jdcolumn'
CHILD=: a:

STATE=: <;._2 ]0 : 0
typ
shape
unique
)

unique=: 0 NB. default STATE value

NB. =========================================================
init=: 3 : 0
Cloc =: '_',(>LOCALE),'_'
coinserttofront 'jdt',typ
)

NB. cols mapped as required except for a few cases where all are mapped up front
open=: 3 : 0
init ''
if. (-.APIRULES)+.(<OP)e.'reference';'tableappend';'validate';'info' do.
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
size=. >. (4>.Tlen) * (*/shape) * DATASIZE__typ

NB. createmap y ; Padvar>.@*size

jdcreatejmf (PATH,y);Padvar>.@*size
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
'resizemap'trace t
jdunmap (name,Cloc);size
mapcolfile name
)

NB. get size of mapped file
getmapsize=: 3 : 0
try.
  msize_jmf_ 6 pick (({."1 mappings_jmf_) i. <y,Cloc){mappings_jmf_
catch.
  0
end.
)
NB. append data y to mapped name x
appendmap =: 4 : 0
req=. +/ 7!:5 x;'y'
act=. getmapsize x
if. req > act do.
  resizemap x ; Padvar>.@*req
end.
". 'x=:x,y' rplc 'x';x
EMPTY
)
NB. replace with data y to mapped name x
replacemap =: 4 : 0
req=. 7!:5 <'y'
act=. getmapsize x
if. req > act do.
  resizemap x ; Padvar>.@*req
end.
(x)=: y
EMPTY
)

NB. =========================================================
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
