NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. Jd API
NB. Jd uses locales (Read__d'from table')
NB. Jd API wraps this for a possibly more convenient interface
NB. Jd API provices same interface to JD in task as to JD sever

NB. jd_cmd that uses abc must do jd_abc ... and not jd'abc ... to get errors

0 : 0
ideas on error message

locale jde contains names to include in jdlast

new command starts with coerease<'jde'

info about the op (as it progresses but often just before assert)
is put in locale jde

tab_jde_=: 'mytab'

error processing adds all the names in jde to jdlast as name: value

preferred error usage:

'messed up'                                 assert condition
('insert table * col * bad'erf tab;col) assert condition 
)

coclass'jd'

todo=: 0 : 0
*** csvrd
boolean/varbyte CSTITCH doesn't work - see test/api_csvout.ijs

*** enum
support is incomplete
not supported in csvwr/csvrd

*** bulk update by key with inplace update

*** bulk insert - procdures

*** bulk merge (update and insert)
)

NB. 'insert table * col * bad'erf table;col
erf=: 4 : 0
y=. ')',~each'(',each boxopen y
i=. ('*'=x)#i.#x
t=. 'ABCDEFGHI'{.~#i
x=. t i}x
x rplc  ,(,.<"0 t),.,.boxopen y
)

JDOK=: ,.<'Jd OK'


0 : 0
API internal globals

 DB - database name - simple name - jdadmin connects to files and access rules

jd_... verbs typically start with getdb'' that sets:
 FLOC - locale of folder with database
 DLOC - locale of databse
)

jd_z_=: jd_jd_

demos=: (<JDP,'demo/'),each 'sandp/sandp.ijs';'northwind/northwind.ijs';'sed/sed.ijs';'vr/vr.ijs'

NB. jdget 'tab col'
jd_get=: 3 : 0
a=. bdnames y
ECOUNT assert 2=#a
d=. getdb''
t=. getloc__d {.a
cs=. '.'strsplit >{:a
ids=. a:
for_c. }:cs do.
 src=. getloc__t c
 'Missing references are not supported by get' assert 0 <: datl__src
 ids=. ids { datl__src
 t=. getreferenced__src''
end.
src=. getloc__t {:cs
select. <typ__src
 case. <'reference' do. r=. ids{a:{datl__src
 case. <'varbyte'   do.
  'Referenced varbyte data is not supported by get' assert r-:a:
  r=. (a:{dat__src);a:{val__src
 case.  do. r=. ids{a:{dat__src NB. forcecopy
end.
r
)
NB. 'tab';'col';dat [;val]
NB.! should enforce no hash or related data
jd_set=: 3 : 0
if. 3=#y do.
 'tab col dat'=. y
elseif. 4=#y do.
 'tab col dat val'=. y
elseif. 1 do.
 ECOUNT assert 0
end.
d=. getdb''
t=. getloc__d tab
snk=. getloc__t col
'jde: wrong shape' assert ($dat)-:$dat__snk
'jde: wrong type'  assert (3!:0 dat)=3!:0 dat__snk
if. 'varbyte'-:typ__snk do.
 'jde: no val and varbyte' assert 0=nc<'val'
 'jde: val wrong length' assert (+/{:"1 dat)=#val
 
 NB.! rsizemap__snk 'val';#val does not work (error on remap???) - workaround
 jdunmap n=. 'val',Cloc__snk
 f=. PATH__snk,'val'
 ferase f
 jdcreatejmf f;#val
 jdmap n;f;f
 val__snk=. val
else.
 'jde: val and not varbyte' assert _1=nc<'val'
end. 
dat__snk=. dat
JDOK
)

initserver_z_=: 3 : 0
if. ''-:y do.
 d=. {."1[1!:0 jpath JDP,'config/server_*.ijs'
 >_4}.each 7}.each d
 return.
end. 
load'~addons/ide/jhs/core.ijs'
load JDP,'config/server_',y,'.ijs'
smoutput BIND_jhs_,':',":PORT_jhs_
smoutput jdadmin''
smoutput 'OKURL',;' ',each OKURL_jhs_
init_jhs_''
)

vsub=: 3 : 0
'bad arg: pairs of names;values' assert (2<:#y)*.0=2|#y
t=. (((#y)%2),2)$y
(,each{."1 t),.{:"1 t NB. ugly make scalar col names lists
)

dbpath=: 3 : 0
i=. ({."1 DBPATHS)i.<,y
if. i=#DBPATHS do. throw JDE1000 end.
r=. ;i{{:"1 DBPATHS
r
)

jd_createdb=: 3 : 0
ECOUNT assert 0=#y
t=. dbpath DB
'w'jdadminlk t
'f db'=. getfolder''
Create__f db
JDOK
)

NB. box blank delimited name and the rest
bd2=: 3 : 0
if. 0=L.y do.
 t=. dltb y
 i=. t i. ' '
 dltb each (i{.t);}.i}.t
else.
 dltb each y 
end.
)

NB. box 2 blank delimited names and the rest
bd3=: 3 : 0
if. 0=L.y do.
 t=. dltb y
 i=. t i. ' '
 dltb each (<i{.t),bd2 i}.t
else.
 dltb each y 
end.
)

jd_createtable=: 3 : 0
erase<'DATACOL_jd_'
if. 0=L.y do. NB. string parse has blanks in col defs
 a=. bdnames y
 y=. ''
 if. '/a'-:;{.a do.
  y=. 4{.a
  a=. 4}.a
 end.
 y=. y,{.a NB. table name
 a=. }.a
 y=. y,<;' ',each a
end. 
a=. y
if. '/a'-:;{.a do.
 alloc=. ;_1".each 3{.}.a
 EALLOC assert 0<alloc
 alloc=. 4 1 1>.alloc
 a=. 4}.a
else. 
 alloc=. ROWSMIN_jdtable_,ROWSMULT_jdtable_,ROWSXTRA_jdtable_
end.

if. '/d'-:;{.a do.
 createfromarray }.a
 return.
end. 
vtcname t=. >0{a NB. table
a=. }.a
a=. ;cutcoldefs each a
if. #a do.
 b=. ><;._2 each a,each' '
 n=. {."1 b
 vtcname each n
 duplicate_assert n
 ETYPE assert (1{"1 b)e.TYPES
 q=. _1".each 2}."1 b
 s=. -.+./"1 >_1-:each q
 p=. -.+./"1 >1-:each 0>each q
 'bad trailing shape' assert s,p
end.
a=. }:;a,each','
d=. getdb''
Create__d t;a;'';alloc   NB. cols;data;alloc
JDOK
)

jdcdef=: 3 : 0
v=. vsub ,y
ns=. {."1 v
vs=. {:"1 v
vtcname each ns
duplicate_assert ns
typ=. ;3!:0 each vs
ETYPE assert 8>:ts
typ=. typ{'';'boolean';'byte';'';'int';'';'';'';'float'
ts=. ":each }.each $each vs
ETALLY assert c={.c=. ;#each vs
deb _3}.' ',;ns,each' ',each typ,each' ',each ts,each<' , '
)

jdfixcolnames=: 3 : 0
v=. vsub ,y
ns=. {."1 v
vs=. {:"1 v
ns=. ns rplc each <'.';'-';' ';'_'
,ns,.vs
)
createfromarray=: 3 : 0
vtcname t=. ;0{y NB. table
v=. vsub }.y
ns=. {."1 v
vs=. {:"1 v
ns=. ns rplc each <'.';'--' NB. table.col -> table--col

a=. t,' ',jdtdeffromarray }.y

jd_createtable a
jd_insert t;,ns,.vs NB. names changed (. -. --)
JDOK
)

NB. validate dan name -same as table/col except jd prefix is allowed
vdname=: 3 : 0
('invalid name ',y)assert (0~:#y) *.(2=3!:0 y) *. (2>$$y) *. *./-.'/\*. ' e. y
)

NB. validate table/col name - used as a file folder
NB. must be non-empty string without /\*. or blank
NB. must not start with jd...
vtcname=: 3 : 0
('invalid name ',y)assert (-.'jd'-:2{.y) *. (0~:#y) *.(2=3!:0 y) *. (2>$$y) *. *./-.'/\*. ' e. y
)

jd_createcol=: 3 : 0
erase<'DATACOL_jd_'
d=. getdb''
if. (1=L.y)*.5=$y do.
 NB. have column values
 dat=. ;{:y
 y=. }:y
 'tab nam type shape'=. y
 ETAB=: tab
 ECOL=: nam
 shape=. _".shape
 if. shape=_ do. shape=. i.0 end.
 ETSHAPE assert 1>:#shape
 ETYPE assert (<type) e. TYPES -. 'enum';'varbyte'
 t=. getloc__d tab
 if. 0=Tlen__t do. 
  a=. getloc__t'jdactive'
  'dat' appendmap__a (#dat)$1
  Tlen__t=: #dat
 end. 
 ESHAPE assert (Tlen__t,shape)-:$dat
 t=. (TYPES i. <type){TYPESj
 ETYPE assert t=3!:0 dat
 y=. tab;nam;type;":shape 
 DATACOL_jd_=: dat
end.
y=. bdnames y
ETAB=: ;0{y
ECOL=: ;1{y
vtcname ECOL
ECOUNT assert 3 4 e.~#y
if. 4=#y do.
  ETSHAPE assert 1>:#_".;{:y
end.  
InsertCols__d ({.y),< ;' ',~each}.":each y
JDOK
)

jd_dropcol=: 3 : 0
y=. bdnames y
ECOUNT assert 2=#y
d=. getdb''
t=. getloc__d ;{.y
if. ({:y)e.{."1 jdcols {.y do.
 assertnodynamic y
 DeleteCols__d y
 'dropcol jddeletefolder failed'assert -.fexist PATH__t,;{:y
end. 
JDOK
)

NB. release lock, jddeletefolder, admin unchanged
jd_dropdb=: 3 : 0
ECOUNT assert 0=#y
'f db'=. getfolder''
t=. dbpath db
'x' jdadminlk t NB. should be done after Drop - see similar in jdadmin
Drop__f db
jddeletefolder t
'dropdb jddeletefolder failed'assert -.fexist t
JDOK
)

jd_droptable=: 3 : 0
if. 0~:L.y do. y=. ;y[ECOUNT assert 1=#y end.
d=. getdb''
if. (<y)e. NAMES__d do.
 assertnoreference y
 Drop__d y
end.
'droptable jddeletefolder failed'assert -.fexist PATH__d,y
JDOK
)

readstart=: 3 : 0
tempcolclear''
if. 0~:L.y do. y=. ;y[ECOUNT assert 1=#y end.
OPTION_e=: OPTION_lr=: 0
while. '/'={.y do.
 if. '/lr '-:4{.y do.
  y=. dlb 4}.y
  OPTION_lr=: 1
 elseif. '/e '-:3{.y do.
  y=. dlb 3}.y
  OPTION_e=: 1
 elseif. 1 do.
  'unknown option'assert 0
 end.
end.
y
)

jd_read=: 3 : 0
y=. readstart y
d=. getdb''
Read__d y
)

jd_reads=: 3 : 0
y=. readstart y
d=. getdb''
if. OPTION_lr do.
 Read__d y
else. 
 Reads__d y
end.
)

jd_update=: 3 : 0
ECOUNT assert 2<:#y
d=. getdb''
Update__d ({.y),<(1{y),<vsub 2}.y
JDOK
)

jd_delete=: 3 : 0
y=. bdnames y
ECOUNT assert 2=#y
d=. getdb''
Delete__d y
JDOK
)

jd_datatune=: 3 : 0
ECOUNT assert 2<:#y
d=. getdb''
t=. getloc__d {.y
jdn=. NAMES__t
jdn=. (-.(<'jd')=2{.each jdn)#jdn
(NAME__t;<jdn)jddatatune__d vsub}.y
)

NB. run custom db jd_x... op in db locale if it exists
jd_x=: 3 : 0
d=. getdb''
JDE1001 assert 3=nc<'jd_',OP,'__d' 
('jd_',OP,'__d')~y
)

NB. Revert (in case of not unique) does not work on dynamic cols!
jd_createunique=: 3 : 0
y=. bdnames y
ECOUNT assert 2<:#y
d=. getdb''
validtc__d y
try.
 MakeUnique__d ({.y),<}.y
catchd.
 DeleteCols__d ({.y),<'jdunique', ;'_',each }.y
 'not unique'assert 0
end.
JDOK
)

jd_createhash=: 3 : 0
y=. bdnames y
ECOUNT assert 2<:#y
d=. getdb''
validtc__d y
MakeHashed__d ({.y),<}.y
JDOK
)

jd_loadcustom=: 3 : 0
f=. (dbpath DB),'/custom.ijs'
if. -.fexist f do. throw 'jde: proc file does not exist' end.
d=. getdb''
aggcreate__d''
load__d f
JDOK
)

NB. left1 only join (fast and simple)
jd_ref=: 3 : 0
y=. bdnames y
ECOUNT assert 4=#y
d=. getdb''
t=. (2,(#y)%2)$y
validtc__d"1 t
t=. ({."1 t),.<"1 (}."1 t)
NB. MakeRef__d t
n=. 'jdref', ;'_'&,&.> ; boxopen&.> }.,t
loc=. getloc__d {.{.t
t=. Create__loc n;'ref';<t
JDOK
)

NB. all join types
jd_reference=: 3 : 0
y=. bdnames y
ECOUNT assert (4<:#y)*.0=2|#y
d=. getdb''
t=. (2,(#y)%2)$y
validtc__d {.t
validtc__d {:t
t=. ({."1 t),.<"1 (}."1 t)
MakeRef__d t
JDOK
)

jd_tableinsert=: 3 : 0
y=. ca y
ECOUNT assert 3=#y
'snkt srct srcdb'=. y
'srcdb same as snkdb' assert -.DB-:srcdb
d=. getdb''
t=. getloc__d snkt

db=. DB
try.
 jdaccess srcdb NB.! possible security implication
 d=. getdb''
catchd.
 jdaccess db
 'invalid srcdb'assert 0 
end.

jdaccess db
Append__t getloc__d srct
JDOK
)

jd_tableappend=: 3 : 0
y=. ca y
ECOUNT assert 2 3 e.~#y
'snkt srct srcdb'=. y
'srcdb same as snkdb' assert -.DB-:srcdb
d=. getdb''
snktloc=. getloc__d snkt
assert 0=#SUBSCR__snktloc['dynamic dependencies - use tableinsert or dropdynamic+dynamic'
a=. jdcols snkt
snkcs=. {:"1 a
snkns=. {."1 a
db=. DB
try.
 jdaccess srcdb NB.! possible security implication
 d=. getdb''
 a=. jdcols srct
 srccs=. {:"1 a
 srcns=. {."1 a
 srctloc=. getloc__d srct
 new=. Tlen__srctloc
catchd.
 jdaccess db
 'invalid srcdb'assert 0 
end.
jdaccess db
t=. snkns-.srcns
if. #t do. throw 'required cols missing in src: ',;' ',each t end.
for_i. i.#snkns do.
 a=. i{snkcs
 b=. i{srccs
 assert NAME__a-:NAME__b
 assert typ__a-:typ__b
 assert shape__a-:shape__b
 
 getloc__snktloc NAME__a NB. make sure col is mapped
 getloc__srctloc NAME__b  NB. make sure col is mapped
 
 assert (}.$dat__a)-:}.$dat__b
end.

for_i. i.#snkns do.
 a=. i{snkcs
 b=. i{srccs
 if. 'varbyte'-:typ__a do.
   v=. 0,~#val__a 
  'val' appendmap__a val__b
  'dat' appendmap__a v+"1 dat__b
 else.
  'dat' appendmap__a dat__b
 end. 
end.
d=. getdb''
t=. getloc__d snkt
a=. getloc__t'jdactive'
b=. getloc__srctloc'jdactive'
'dat' appendmap__a dat__b
Tlen__t=: new+Tlen__t
JDOK
)

jd_tablecopy=: 3 : 0
y=. bdnames y
ECOUNT assert 3=#y
'snk src srcdb'=. y
'srcdb same as snkdb' assert -.DB-:srcdb
snkpath=. jpath(dbpath DB),'/',snk
assert 0=#1!:0<jpath snkpath['snk table already exists'

db=. DB
try.
 jdaccess srcdb NB.! possible security implication
 srcpath=. jpath(dbpath DB),'/',src
 assert 'table'-:jdfread srcpath,'/jdclass'
catchd.
 jdaccess db
 'invalid srcdb'assert 0 
end.

jdaccess db
snkpath=. '"',snkpath,'"'
srcpath=. '"',srcpath,'"'
jd_close''
if. IFWIN do.
 r=. shell 'robocopy ',srcpath,' ',snkpath,' *.* /E'
 if. +/'ERROR' E. r do.
  smoutput r 
  assert 0['robocopy failed'
 end.
else.
 shell 'cp -r ',srcpath,' ',snkpath
end.
JDOK
)

jd_tablemove=: 3 : 0
y=. bdnames y
ECOUNT assert 3=#y
'snk src srcdb'=. y
'srcdb same as snkdb' assert -.DB-:srcdb
snkpath=. jpath(dbpath DB),'/',snk
assert 0=#1!:0<jpath snkpath['snk table already exists'

db=. DB
try.
 jdaccess srcdb NB.! possible security implication
 srcpath=. jpath(dbpath DB),'/',src
 assert 'table'-:jdfread srcpath,'/jdclass'
catchd.
 jdaccess db
 'invalid srcdb'assert 0 
end.

jdaccess db
jd_close'' NB. does not release lock
assert 1=snkpath frename srcpath['frename failed'
JDOK
)

opened=: 3 : 0
ECOUNT assert 0=#y
r=. ''
for_n. NAMES_jd_ do.
 f=. Open_jd_ >n
 p=. PATH__f
 for_d. CHILDREN__f do.
  r=. r,<p,NAME__d
 end.
end.
r
)

jd_close=: 3 : 0
ECOUNT assert 0=#y

NB. read error (tab not found) orphans jdquery local
NB. coerase jdquery local (copath has number locals) leaves a damaged local
NB. brute force get rid of all jdquery locales
for_n. conl 1 do.
 if. 'jdquery'-:;{.copath n do. coerase n end.
end. 

t=. opened''
for_a. t do.
 a=. ;a
 i=. a i:'/'
 f=. Open_jd_ i{.a
 Close__f (>:i)}.a
end.

NB. coerase all folder locals for a clean slate
for_n. conl 1 do.
 if. 'jdfolder'-:;{.copath n do. coerase n end.
end.get
NAMES_jd_=: '' 
CHILDREN_jd_=: ''

JDOK
)

NB. dynmaic verb must run in base - it is copied to base to run
jd_createdynamic=: 3 : 0
jd_dropdynamic''
d=. getdb''
assert 3=nc<'dynamic__d'['dynamic not defined by custom.ijs'
createdynamic__=:  (5!:1<'dynamic__d')5!:0
createdynamic__ ''
JDOK
)

dropdynsub=: 3 : 0
d=. getdb''
typ=. ;{.y
y=. }.y
select. typ

fcase. 'ref' do.
 ECOUNT assert 4=#y

case.'reference' do.
 ECOUNT assert (4<:#y)*.0=2|#y
 t=. (2,(#y)%2)$y
 validtc__d {.t
 validtc__d {:t
 t=. ({."1 t),.<"1 (}."1 t)
 fn=. 'jd',typ,,;'_'&,&.> ; boxopen&.> }.,y
 f=. jdgl ;{.{.t
 fb=. ({."1 SUBSCR__f)=<fn
 EDNONE assert 1=+/fb
 gn=. '^.',(;{.y),'.jd',typ,,;'_'&,&.> ; boxopen&.> }.,y
 g=. jdgl ;{.{:t
 gb=. ({."1 SUBSCR__g)=<gn
 EDNONE assert 1=+/gb
 jddeletefolder PATH__f,fn
 SUBSCR__f=: (-.fb)#SUBSCR__f
 writestate__f''
 SUBSCR__g=: (-.gb)#SUBSCR__g
 writestate__g''
case.'hash';'unique' do.
 ECOUNT assert 2<:#y
 validtc__d y
 fn=. 'jd',typ,,;'_'&,&.> ; boxopen&.> }.,y
 f=. jdgl ;{.y
 fb=. ({."1 SUBSCR__f)=<fn
 EDNONE assert 1=+/fb
 a=. {:{:fb#SUBSCR__f
 'dropdynamic hash/unique is used by reference' assert 1=+/a={:"1 SUBSCR__f
 SUBSCR__f=: (-.fb)#SUBSCR__f
 writestate__f''
 p=. PATH__f,fn
 jd_close'' NB. reopened and must be closed to delete
 jddeletefolder p
case.do.
 'dropdynamic unknown type'assert 0
end.
jd'close'
JDOK
)

jd_dropdynamic=: 3 : 0
jd_close''
y=. bdnames y
if. #y do. dropdynsub y return. end.
p=. dbpath DB
d=. 1!:0 <jpath p,'/*'
d=. (<p,'/'),each {."1 ('d'=;4{each 4{"1 d)#d
d=. (fexist d,each <'/jdclass')#d
d=. ((<'table')=jdfread each d,each <'/jdclass')#d
for_n. d do.
 dd=. {."1[1!:0 <jpath'/*',~;n
 b=. (<'jdhash_')=7{.each dd
 b=. b+.(<'jdreference_')=12{.each dd
 b=. b+.(<'jdunique_')=9{.each dd
 dd=. b#dd
 jddeletefolder each n,each,'/',each dd
 f=. '/jdstate',~;n
 s=. 3!:2 jdfread f
 i=. ({."1 s)i.<'SUBSCR'
 s=. (<0 3$a:) (<i,1)}s
 (3!:1 s) fwrite f
end.
JDOK
)

jd_dropfilesize=: 3 : 0
getdb''
p=. jpath dbpath DB
maps=. mappings_jmf_
maps=. maps /:1{"1 maps
d=. 1{"1 maps
b=. (;(<p)-:each (#p){.each d)
d=. b#d
h=. b#{."1 maps
rn=. ra=. rz=. ''
for_i. i.#h do.
 n=. >i{h
 type=. 3!:0 n~
 size=. (JTYPES i.type){JSIZES
 shape=. $n~
 dsize=. size**/shape
 msize=. getmsize_jmf_ n
 assert (fsize i{d)=HS_jmf_+msize
 assert msize>:dsize
 rn=. rn,i{d
 ra=. ra,fsize i{d
 rz=. rz,HS_jmf_+dsize
 if. msize>dsize do.
  setmsize_jmf_ n;dsize 
  jdunmap n
  newsize_jmf_ (;i{d);HS_jmf_+dsize
 else.
  jdunmap n
 end. 
end.
jd_close''
('file';'old';'new'),:(<>rn),(<,.ra),<,.rz
)

NB.! needs work
jd_option=: 3 : 0
a=. ;:y
select. ;{.a 
case. 'space' do. optionspace=: 1=0".;1{a
case. 'sort'  do. optionsort =: 1=0".;1{a
case.         do. assert 0['unsupported option'
end.
JDOK
)

jd_gen=: 3 : 0
y=. bdnames y
select. ;{.y
case. 'test' do.
 gentest }.y
case. 'ref2' do.
 'atab arows acols btab brows'=. }.y
 arows=. 0".arows
 acols=. 0".acols
 brows=. 0".brows
 assert arows>:brows
 t=. (arows,12)$'abc def'
 jd_createtable atab
 jd_createtable btab
 jd_createcol atab;'akey' ;'int';'_';i.arows
 jd_createcol atab;'adata';'int';'_';i.arows
 jd_createcol atab;'aref' ;'int';'_';arows$i.brows
 if. acols do.
  t=. (arows,12)$'abc def'
  for_i. i.acols do.
   jd_createcol atab;('a',(":i));'byte';'12';t
  end.
 end. 
 t=. (brows,12)$'abc def'
 jd_createcol btab;'bref';'int' ;'_' ;i.brows
 jd_createcol btab;'bb12';'byte';'12';t
 jd'reference A aref B bref'rplc'A';atab;'B';btab NB.! jd_reference_jd_ fails
case. 'one' do.
 genone }.y
case. 'two' do.
 gentwo }.y
case. do.
 assert 0['unknown gen type'
end.
JDOK
)

NB. gen two f 10 g 3
NB. generate 2 tables suitable for testing dynamics
gentwo=: 3 : 0
 'atab arows btab brows'=. 4{.y
 arows=. 0".arows
 if. 0=#brows do. brows=. 3>.>.arows%10 else. brows=. 0".brows end.
 jd_createtable atab
 jd_createtable btab
 jd_createcol atab;'a1';'int';'_';i.arows
 jd_createcol atab;'a2';'int';'_';arows$i.brows
 jd_createcol btab;'b2';'int';'_' ;i.brows
)

genone=: 3 : 0
'atab arows acols'=. y
jd_createtable atab
d=. i.0".arows
for_i. i.0".acols do. 
 NB. jd_close''
 jd_createcol atab;('a',":i);'int';'_';d
end. 
)

NB. insert of 1st col sets Tlen
NB. subsequent creaecol gets defauilt data of right size
NB. this means set works
NB. not optimal efficient as dat is created and then set
gentest=: 3 : 0
t=. bdnames y
ECOUNT assert 2=#t
'tab n'=. t
n=. 0".n
jd_droptable tab
jd_createtable tab;'x int'
jd_insert tab;'x';i.n NB. insert sets Tlen and new col creates get default data
jd_createcol tab,' datetime datetime'
jd_set tab;'datetime';(n#20130524203132)-10000000000*?.n#20
jd_createcol tab,' float float'
jd_set tab;'float';0.5+i.n
jd_createcol tab,' boolean boolean'
jd_set tab;'boolean';n$0 1 1
jd_createcol tab,' int int'
jd_set tab;'int';100+i.n
jd_createcol tab,' byte byte'
jd_set tab;'byte';n$AlphaNum_j_
jd_createcol tab,' byte4 byte 4'
jd_set tab;'byte4';(n,4)$AlphaNum_j_
jd_createcol tab,' varbyte varbyte'
if. 0~:n do.
 t=. n$?.100000$10
 t=. (0,}:+/\t),.t
 jd_set tab;'varbyte';t;(+/{:"1 t)$AlphaNum_j_
end. 
JDOK
)

NB.! needs work for ref/reference/hash columns
NB.! needs option to fix Tlen problems by dropdynamic/cutting back/dynamic
NB.! needs to validate unique
NB. assert for completely unexpected errors
NB. formatted report for more likely errors
jd_validate=: 3 : 0
d=. getdb''
r=. ''
try.
 assert (#NAMES__d)=#CHILDREN__d
 for_i. i.#NAMES__d do.
  t=. i{CHILDREN__d    NB. table locale
  len=. Tlen__t
  for_j. i.#NAMES__t do.
   n=. >j{NAMES__t
   c=. getloc__t n NB. map as required
   'bad child locale' assert c=j{CHILDREN__t

   if. 'jdindex'-:n do.
   
   elseif. 'jdunique'-:8{.n do.
    NB. assert len<#hash__c
   elseif. 'jdhash'-:6{.n do.
    NB. assert len=#link__c
   elseif. 'jdreference_'-:12{.n do.
    if. typ__c-:'ref' do.
     if. (-.dirty__c)*.len~:#datl__c do. r=. 'bad ref datl count: ',NAME__t,' ',NAME__c,LF end.
    else.
     NB. validate datl datr hashl hashr
    end.
  
   elseif. 1 do.
    if. len~:#dat__c do.
     r=. r,'bad count: ',NAME__t,' ',NAME__c,' ',(":#dat__c),' (Tlen is ',(":len),')',LF
    end.
    if. typ__c-:'varbyte' do.
     assert (len,2)-:$dat__c
     assert shape__c-:''
    else.
     assert shape__c-:}.$dat__c 
    end. 
    k=. ({."1 mappings_jmf_)i.<'dat_',(;c),'_'
    mr=. k{mappings_jmf_
    ms=. msize_jmf_ >6{mr
    fs=. fsize 1{mr
    assert fs=ms+HS_jmf_
   end.
  end.
 end.
catchd.
 r=. r,'unexpected error',LF,13!:12''
end.
,.'Jd report validate';r
)

getfolder=: 3 : 0
db=. dbpath DB
p=. jpath db
i=. p i:'/'
(Open_jd_ i{.p);(>:i)}.p
)

getdb=: 3 : 0
db=. dbpath DB
'db damaged'assert -.fexist db,'/jddamage'
if. -.'database'-:jdfread db,'/jdclass' do. throw JDE1000 end.
i=. db i:'/'
floc_z_=: f=. Open_jd_ jpath i{.db
dloc_z_=: Open__f (>:i)}.db
)

NB. unique/hash/reference/ref
NB. valid tab and cols - float/varbyte/enum not allowed unless ALLOW_FVE (for old style tests)
validtc=: 3 : 0
b=. (<'jd')=2{.each y
if. +./b do. throw 'jde: invalid name: name (NAME)' rplc 'NAME';;{.b#y end.
if. -.({.y)e.NAMES do. throw 'jde: not found: table (TAB)' rplc 'TAB';;{.y end.
tloc_z_=: t=. getloc {.y
a=. (}.y)-.NAMES__t
if. #a do. throw 'jde: not found: table (TAB) column (COL)' rplc 'TAB';(;{.y);'COL';;{.a end.
for_c. }.y do.
 w=. getloc__t c
 if. -.ALLOW_FVE do.
  if. 'varbyte'-:typ__w do. 'varbyte not allowed'assert 0 end.
  if. 'float'-:typ__w   do. 'float not allowed'  assert 0 end.
  if. 'enum'-:typ__w    do. 'enum not allowed'  assert 0 end.
 end. 
end. 
)

NB. get blank delimited (possibly in "s) arg from string
getarg=: 3 : 0
a=. dlb y
if. '"'={.a do.
 a=. }.a
 i=. a i.'"'
 'jde: unmatched double quote' assert i<#a
 r=. i{.a
 a=. }.i}.a
else.
 i=. a i.' '
 r=. i{.a
 a=. i}.a
end.
r;a
)

getopt=: 3 : 0
a=. dlb y
if. '/'={.a do.
 i=. a i.' '
 r=. }.i{.a
 a=. i}.a
else.
 r=. ''
end.
r;a
)

jdex=: 3 : 0
y=. dltb y
d=. toJ jdfread JDP,'doc/user.html'
d=. dltb each<;._2 d,LF
if. ''-:y do.
 s=. 'NB. example '
 d=. (((#s){.each d)=<s)#d
 ;LF,~each(#s)}.each d
 return.
end.
if. y-:'read' do. y=. 'reads' end.
s=. 'NB. example ',y
i=. >:((-#s){.each d)i.<s
d=. i}.d
assert 0~:#d['example not found'
i=. 1 i.~ 0=;#each dltb each d
assert 20>i['example too long'
d=. i{.d
d=. ;d,each LF
d=. d rplc '&lt;';'<';'&gt;';'>'
f=. '~temp/jdexample.ijs'
d fwrite f
NB. t=. jdaccess''
NB. jdadminx'example'
loadd f
NB. jdaccess t
)

jd_readtc=: 3 : 0
y=. readstart y

'readtc requires :::exp:::' assert ':::'-:3{.y
y=. 3}.y
i=. 1 i.~':::' E. y
'readrc unmatched :::'assert i<#y
s=. i{.y
tempcol s
y=. (3+i)}.y

d=. getdb''
if. OPTION_lr do.
 r=. Read__d y
else. 
 r=. Reads__d y
end. 
tempcolclear''
r
)

tempcol=: 3 : 0
 t=. ;: y
 r=. ''
 for_i. i.#t do.
  a=. i{t
  
  if. (_2~:nc a)*.-.'_jd_'-:_4{.;a do.
   a=. ;a
   j=. a i.'_'
   tab=. j{.a
   col=. }.j}.a
   d=. getdb''
   ('readtc X not a table'rplc'X';a) assert (<tab)e. NAMES__d
   g=. jdgl tab
  
   if. (>:i)<#t do.
    if. (<'=:')=(i+1){t do.
     NB. create temp col
     ('readtc X already exists'rplc'X';a) assert -.(<col)e.NAMES__g
     c=. cocreate''
     CHILDREN__c=: ''
     Cloc__c=: '_',(;c),'_'
     LOCALE__c=: c
     j=. a i.'_'
     NAME__c=: col
     NAMES__c=: ''
     PARENT__c=: g
     cp=. 18!:2 getloc__g 'jdactive'
     cp 18!:2 c
     TEMPCOLS=: TEMPCOLS,(<a),c
     r=. r,<'dat_',(;c),'_'
     continue.
    end.
   end. 
    ('readtc X does not exist'rplc'X';a) assert (<col)e.NAMES__g
    c=. getloc__g col
    r=. r,<'dat_',(;c),'_'
  else.
   'readtc ". not allowed'assert -.(<'".')-:a
   r=. r,a
  end. 
 end. 
 ".;r,each' '
 for_i. i.#TEMPCOLS do.
  c=. {:i{TEMPCOLS
  shape__c=: }:$dat__c
  typ__c=: ;(1 4 8 2 i. 3!:0 dat__c){'boolean';'int';'float';'byte'
  p=. PARENT__c
  ('readtc X has wrong number of rows'rplc'X';;{.i{TEMPCOLS)assert Tlen__p=#dat__c
 end.
)

tempcolclear=: 3 : 0
coerase{:"1 TEMPCOLS
TEMPCOLS=: i.0 2
)

assertnoreference=: 3 : 0
t=. jdgl y
s=. ;(<'jdref')=5{.each {."1 SUBSCR__t
'table has reference' assert 0=+/s
)

assertnodynamic=: 3 : 0
t=. jdgl ;{.y
'col has dynamic' assert  -.({:y)e.;{:"1 SUBSCR__t
)

jd_renametable=: 3 : 0
a=. bdnames y
ECOUNT assert 2=#a
assertnoreference ;{.a
t=. jdgl {.a
new=. ((->:#NAME__t)}.PATH__t),;{:a 
old=. }:PATH__t
jd'close'
new frename old
JDOK
)

jd_renamecol=: 3 : 0
a=. bdnames y
ECOUNT assert 3=#a
assertnodynamic 2{.a
t=. jdgl 2{.a
new=. ((->:#NAME__t)}.PATH__t),;{:a 
old=. }:PATH__t
jd'close'
new frename old
JDOK
)
