NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. jdget 'tab col'
jd_get=: 3 : 0
a=. bdnames y
ECOUNT assert 2=#a
t=. getloc__dbl {.a
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
t=. getloc__dbl tab
snk=. getloc__t col
EDERIVED assert 0=derived__snk 
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
a=. '/in 0'getopts y
ECOUNT assert 3<:#a
tab=. ,;{.a
FETAB=: tab
t=. jdgl tab
'ns vs rows'=. _2 fixpairs__t }.a
(-.option_in) keyindex tab;,ns,.vs
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
'FETAB FECOL'=: 2{.y
'tab col'=. 2{.y
newt=. ;2{y
c=. jdgl 2{.y
oldt=. typ__c
if. newt-:oldt do. JDOK return. end.
EDERIVED assert 0=derived__c 
ETYPE assert (<newt)e.;:'int int1 int2 int4 intx'
ETYPE assert 'int'-:3{.oldt
data=. >{:{:jdi_read '"',col,'"',' from ',tab NB. does conversion from intx to int

NB. validate range and pick smallest intx if newt is intx
min=. <./data
max=. >./data

select. newt
case. 'int1' do. EINT1 assert (min>:I1MIN)*.max<:I1MAX
case. 'int2' do. EINT2 assert (min>:I2MIN)*.max<:I2MAX
case. 'int4' do. EINT4 assert (min>:I4MIN)*.max<:I4MAX
case. 'intx' do.
 b=. (min>:I1MIN,I2MIN,I4MIN,IMIN)*.max<:I1MAX,I2MAX,I4MAX,IMAX
 newt=. ;{.b#;:'int1 int2 int4 int'
end.

assertnodynamic 2{.y
assertnotptable tab
newcol tab;col;newt;data
JDOK
)

NB. redefine col with new type and/or data - preserve col create order
newcol=: 3 : 0
'tab col type data'=. y
t=. jdgl tab
co=. cco_read__t''
colx=. col,'_temp_col_during_type_change' NB. kludge to avoid conflict
jd_renamecol tab;col;colx NB. rename old col out of the way
jd_createcol tab;col;type;data
jd_dropcol tab;colx
t=. jdgl tab
cco_write__t co NB. restore cco
)

NB. change col byte trailing shape
jd_byten=: 3 : 0
y=. bdnames y
y=. y,(3=#y)#<' '
ECOUNT assert 4=#y
'FETAB FECOL'=: 2{.y
'tab col s fill'=. y
c=. jdgl 2{.y
EDERIVED assert 0=derived__c 
ETYPE assert (typ__c-:'byte')*.-.''-:shape__c

s=. _1".s
'bad shape'assert (s<10000)*.s>:0

'bad fill'assert (1=#,fill)*.2=3!:0 fill
fill=. {.fill

assertnodynamic 2{.y
assertnotptable tab
if. shape__c~:s do.
 data=. ((#dat__c),s){.!.fill dat__c
 newcol tab;col;('byte ',":s);data
end.  
JDOK
)

NB. run custom db jd_x... op in db locale if it exists
jd_x=: 3 : 0
JDE1001 assert 3=nc<'jd_',OP,'__dbl' 
('jd_',OP,'__dbl')~y
)

jd_ref=: 3 : 0
y=. ca'/left 0'getopts y
option_left=: option_left +. FORCELEFT
ECOUNT assert (4<:#y)*.0=2|#y
t=. (2,(#y)%2)$y
0 validtc__dbl {.t NB. ptable allowed on left
validtc__dbl {:t

NB. verify col pairs match type and shape
ta=. getloc__dbl {.{.t
tb=. getloc__dbl {.{:t
a=. }.{.t
b=. }.{:t
'_ char not allowed in col'assert -.'_'e.;a,b
for_i. i.#a do.
 ca=. getloc__ta i{a
 cb=. getloc__tb i{b
 'ref types not the same'assert typ__ca-:typ__cb
 'ref trailing shapes not the same'assert shape__ca-:shape__cb
end.

t=. ({."1 t),.<"1 (}."1 t)
ts=. getparttables ;{.y
ts=. ts#~PTM~:;{:each ts
n=. 'jdref', ;'_'&,&.> ; boxopen&.> }.,t
for_t1. ts do.
 a=. ;t1
 h=. jdgl :: 0: a,' ',n
 if. h-:0 do.
  loc=. getloc__dbl a
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
if. 0=#DB do. JDOK return. end.
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
end.
NAMES_jd_=: '' 
CHILDREN_jd_=: ''
dbl=: ''
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

NB. mtm read type op that spins for y seconds
jd_rspin=: 3 : 0
n=. 0 ". y
s=. 6!:1''
while. n>s-~6!:1'' do. end.
JDOK
)

NB. mtm write type op that spins for y seconds
jd_wspin=: 3 : 0
n=. 0 ". y
s=. 6!:1''
while. n>s-~6!:1'' do. end.
JDOK
)
