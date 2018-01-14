NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. jdget 'tab col'
jd_get=: 3 : 0
a=. bdnames y
ECOUNT assert 2=#a
d=. getdb''
t=. getloc__d {.a
c=. getloc__t {:a
select. <typ__c
 case. <'autoindex' do. i.Tlen__t
 case. <'varbyte'   do.
  (forcecopy dat__c);forcecopy val__c
 case.  do. forcecopy dat__c
end.
)

NB. 'tab';'col';dat [;val]
NB. should enforce no hash or related data
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
 
 NB. rsizemap__snk 'val';#val does not work (error on remap???) - workaround
 jdunmap n=. 'val',Cloc__snk
 f=. PATH__snk,'val'
 ferase f
 jdcreatejmf f;#val
 jdmap n;f
 val__snk=: val
else.
 'jde: val and not varbyte' assert _1=nc<'val'
end. 
dat__snk=: dat
JDOK
)

jd_key=: 3 : 0
y=. '/in 0'getoptions y
FETAB=: tab=. ;{.y
(-.option_in) keyindex y
)

jd_flush=: 3 : 0
flush_jmf_''
JDOK
)

NB. change col type
NB.  validate old data for new type
NB.  rename old col out of the way
NB.  create new col with old data
NB.  drop renamed col
NB.  reset createorder file
NB.
NB.  if an error - drop new col and rename old col
NB. link should cause all activiy to happen on linked drive
jd_intx=: 3 : 0
y=. bdnames y
ECOUNT assert 3=#y
'FETAB FECOL'=. 2{.y
'tab col'=. 2{.y
newt=. ;2{y
c=. jdgl 2{.y
oldt=. typ__c
co=. fread pco=. PATH__PARENT__c,'column_create_order.txt'
'new type not intx' assert (<newt)e.;:'int int1 int2 int4 intx'
'old type not intx' assert 'int'-:3{.oldt
d=. >{:{:jd_read col,' from ',tab NB. does conversion from intx to int

NB. validate range and pick smallest intx if newt is intx
min=. <./d
max=. >./d

select. newt
case. 'int1' do. EINT1 assert (min>:i1min)*.max<:i1max
case. 'int2' do. EINT2 assert (min>:i2min)*.max<:i2max
case. 'int4' do. EINT4 assert (min>:i4min)*.max<:i4max
case. 'intx' do.
 b=. (min>:i1min,i2min,i4min,imin)*.max<:i1max,i2max,i4max,imax
 newt=. ;{.b#;:'int1 int2 int4 int'
end.

if. newt-:oldt do. JDOK return. end.
assertnodynamic 2{.y

colx=. col,'_temp_col_during_intx' NB. kludge to avoid conflict
jd_renamecol tab;col;colx NB. rename old col out of the way

try.
 jd_createcol tab;col;newt;d
catchd.
 'intx conversion failed- should not happen' assert 0
end.

jd_dropcol tab;colx
co fwrite pco
to keep create order file 
JDOK
)

NB. run custom db jd_x... op in db locale if it exists
jd_x=: 3 : 0
d=. getdb''
JDE1001 assert 3=nc<'jd_',OP,'__d' 
('jd_',OP,'__d')~y
)

NB. left1 only join (fast and simple) - ref starts out as dirty
jd_ref=: 3 : 0
y=. '/left 0'getoptions y
ECOUNT assert (4<:#y)*.0=2|#y
d=. getdb''
t=. (2,(#y)%2)$y
0 validtc__d {.t NB. ptable allowed on left
validtc__d {:t
t=. ({."1 t),.<"1 (}."1 t)
ts=. getparttables ;{.y
ts=. ts#~PTM~:;{:each ts
n=. 'jdref', ;'_'&,&.> ; boxopen&.> }.,t
for_t1. ts do.
 a=. ;t1
 h=. jdgl :: 0: a,' ',n
 if. h-:0 do.
  loc=. getloc__d a
  c=. Create__loc n;'ref';<($t)$t1,}.,t
  left__c=: option_left
 else.
  'can not change /left option in existing ref'assert left__h=option_left
 end.
end.
JDOK
)

jd_close=: 3 : 0
ECOUNT assert 0=#y
if. fexist 'jdcloseflush',~jdpath'' do. jd_flush'' end.
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

NB. needs work
jd_option=: 3 : 0
a=. ;:y
select. ;{.a 
case. 'space' do. optionspace=: 1=0".;1{a
case. 'sort'  do. optionsort =: 1=0".;1{a
case.         do. assert 0['unsupported option'
end.
JDOK
)
