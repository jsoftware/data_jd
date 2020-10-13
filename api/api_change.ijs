NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. x is upsert key
jd_insert=: 3 : 0
'' jd_insert y
:
FETAB=: tab=. ;{.y
t=. jdgl tab
'ns vs rows'=. _1 fixpairs__t 1}.y
NB. dn=. cn_state__t'derived'
NB. EDERIVED assert 0=#FECOL_jd_=: ;{.ns#~ns e. dn
NB. EMISSING assert 0=#FECOL_jd_=: (NAMES__t#~-.bjdn NAMES__t)-.ns,dn
if. rows<1 do. JDOK return. end.
nv=. ns,.vs
if. isptable tab do.
 x insertptable nv
else.
 markderiveddirty__t''
 if. ''-:x do.
  rows Insert__dbl  ({.y),<nv
 else. 
  x upsert ({.y),(<ns),<vs
 end.
end. 
JDOK
)

insertptable=: 4 : 0
tab=. FETAB
t=. jdgl tab,PTM
pcol=. getpcol__t''
c=. CHILDREN__t {~ NAMES__t i. <pcol
i=. ({."1 y)i.<pcol
parts=. ;{:i{y NB. pcol vals are ints (int, edate, edatetime)
parts=. typ__c pcol_ffromv parts NB.edate to int
nub=. ~.parts

NB. make sure required parts exist
tabs=. (<tab,PTM),each dtb each ":each <"_1 nub
cptab each tabs

if. 1=#nub do.
  jd_insert (tab,PTM,dtb":;nub);,y
else.
 for_part. nub do.
  NB. part type
  if. 2=3!:0 part do.
   i=. <I.part-:"1 parts
  else.
   i=. <I.part=parts
  end.
  d=. i{each{:"1 y
  d=. ({."1 y),.d
  x jd_insert (tab,PTM,dtb":;part);,d
 end.
end. 

NB. create f~ pcol with data
jd_droptable '/reset ',tab,PTM
d=. getpartsx tab
jd_insert (tab,PTM);pcol;typ__c getpcolvals d
JDOK
)

NB. create partition table if it does not already exist
NB. partition table created with same schema and dynamics
cptab=: 3 : 0
i=. y i.PTM
tab=. i{.y
part=. (>:i)}.y
t=. jdgl :: 0: y
if. 0~:t do. i.0 0 return. end. NB. already exists
jd_createtable y
s=. {:jdi_info'schema ',tab
for_i. i.ttally s do.
 d=. i tfrom s
 n=. }.d
 shape=. ;{:d
 shape=. ;(shape=_){shape;''
 d=. ;' ',each(<(;{.d),PTM,part),(1{d),<(;2{d),' ',":shape
 jd_createcol d
end.
s=. {:jdi_info'ref ',tab
for_i. i.ttally s do.
 d=. i tfrom s
 t=. (;{.d),PTM,part
 a=. <;.1 ' ',(2}.;}.d)rplc'_';' '
 ('jd_',}.;{.a)~ t,;}.a
end.
i.0 0
)

jd_delete=: 3 : 0
y=. dltb y
if. 0=L.y do.
 i=. y i.' '
 tab=. i{.y
 w=. (>:i)}.y
else.
 if. 2=#y do.
  tab=. ;{.y
  w=. ;}.y
 else.
  NB. key delete
  tab=. ;{.y
  t=. jdgl tab
  'ns vs rows'=. _2 fixpairs__t }.y
  w=. 0 keyindex tab;,ns,.vs
 end.
end.
FETAB=: tab
if. 2=3!:0 w do. w=. ;{:{:jdi_read 'jdindex from ',tab,' where ',w end. 
if. 0=#w do. JDOK return. end.
if. isptable tab do.
 deleteptable tab;w
else.
 Delete__dbl tab;w
end. 
JDOK
)

deleteptable=: 3 : 0
tab=. ;{.y
t=. jdgl tab,PTM
pcol=. getpcol__t''
w=. ;}.y
'parts tlens'=. getparts tab
base=. 0,}:+/\tlens
i=. <:0 i.~"0 1 w >:/ base
p=. i{parts
nub=. ~.p
wx=. w - i{base
for_n. nub do.
 f=. tab,PTM,;n
 pr=. wx#~p=n     NB. ptable rows (includes base)
 f=. tab,PTM,;n
 jd_delete f;pr
end. 
JDOK
)

NB. table ; where ; pairs
NB. where can be
NB.  read style where clause
NB.  indexes (jdindex values)
NB.  _ for all rows
NB.  col(s) to use with keyindex
jd_update=: 3 : 0
ECOUNT assert 2<:#y
'tab w'=. 2{.y
y=. 2}.y
FETAB_jd_=. ;tab
t=. jdgl FETAB
'ns vs rows'=. _2 fixpairs__t y NB. update rules
if. 2=3!:0 w do.
 NB. read where clause or col(s)
 if. *./(;: ::0:w)e.NAMES__t do. NB. where clause could contain unmatched quote
  NB. key update 
 'name data pairs - odd number' assert (2<:#y)*.0=2|#y
  key=. ;:w NB. search for the
  'key(s) not in pairs'assert 0=#key-.ns
  if. (#key)=#ns do. JDOK return. end. NB. no data to update
  i=. ns i. key
  w=. keyindex tab;,(i{ns),.i{vs
  b=. -.ns e. key  NB. remove keys from pairs
  ns=. b#ns
  vs=. b#vs
 else.
  w=. ;{:,old=. jdi_read 'jdindex from ',tab,' where ',w NB. ; always a list so 1 n$'abc' works
 end. 
else.
 if. w-:_ do. w=. i.Tlen__t end.
 if. 4~:3!:0 w do. NB. see fixtype_num_jdtint_
  if. 1=3!:0 w do. w=. 0+w else. EINDEX assert 0 end.
 end.
 w=. ,w NB. , to allow 1 n$'abc' to work
end.
NB. w is always a list - if it has 1 element, this allows data 1 4$'a'

if. 0=#w do. NB. allow 0 or 1 rows if nothing to do
 ETALLY assert rows e. 0 1
 JDOK return.
end. 

if. (rows=1) *. rows~:#w do. NB. scalar extend to match #w
 rows=. #w
 for_i. i.#vs do.
  d=. >i{vs 
  if. 1=#d do.
   vs=. (<rows#d) i}vs
  end.
 end.
end.

ETALLY assert rows=#w

EDERIVED assert -.+./ns e.~ cn_state__t'derived'

if. -.isptable tab do.
 EINDEX assert (w<Tlen__t),0<:w
 markderiveddirty__t''
 for_i. i.#ns do.
  c=. getloc__t {.i{ns
  w modify__c >i{vs
 end.
 
 derived_mapped_update__t w NB. update derived_mapped cols data
 
else.
 'parts tlens'=. getparts tab
 EINDEX assert (w<+/tlens),0<:w
 base=. 0,}:+/\tlens
 i=. <:0 i.~"0 1 w >:/ base
 p=. i{parts
 nub=. ~.p
 wx=. w - i{base
 for_n. nub do.
  f=. tab,PTM,;n
  pr=. wx#~p=n     NB. ptable rows (includes base)
  dr=. (p=n)#i.#w NB. data rows
  f=. tab,PTM,;n
  for_i. i.#ns do.
   c=. jdgl f,' ',;{.i{ns
   d=. >i{vs
   if. 1~:#d do. d=. dr{d end. 
   pr modify__c d
  end.
 end. 
end. 
JDOK
)

NB. x is key
upsert=: 4 : 0
tab=. ;{.y
t=. jdgl tab
'ns vs'=. }.y
if. 0=#>{.vs do. JDOK return. end.
if. 1=#x do.
 ksrc=. >(0{ns i. x){vs
 c=. jdgl tab;x
 ksnk=. dat__c NB. new ref to dat__c - release asap
else.
 ksrc=. stitchx__t (ns i.x){vs
 ksnk=. stitch__t tab;<x
end. 
r=. ksnk i: ksrc
b=. r<#ksnk

erase'ksnk' NB. could be dat__c ref

if. +/b do.
 update=. tab;(b#r);,ns,.(<b#i.#ksrc){each vs
 jd_update update
end.
b=. -.b
if. +/b do.
 insert=. tab;,ns,.(<b#i.#r){each vs
 jd_insert insert
end. 
)

NB. treat upsert as an insert until the last moment
NB. this simplifies ptable support
jd_upsert=: 3 : 0
ECOUNT assert 2<:#y
'tab key'=. 2{.y
FETAB_jd_=: tab
key=. bdnames key
0 validtc__dbl (<tab),key
key jd_insert tab;2}.y
)
