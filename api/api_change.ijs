NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

coclass'jd'

fsub=: 3 : 0
if. 1=$$y do.
 ,.<"0 y 
else.
 ,.<"1 y 
end.
)


NB. vsub f table
NB. return +/active for unique test
NB. validate count,type,shape
validateinsert=: 4 : 0
ns=. {."1 x
vs=. {:"1 x
d=. getdb''
t=. getloc__d y
all=. ((<'jd')~:2{.each NAMES__t)#NAMES__t NB. all col names
unknown_assert ns-.all
missing_assert all-.ns
duplicate_assert ns

cnt=. _1 NB. all have the same count - get count from first one
for_i. i.#ns do.
 c=. getloc__t i{ns
 cnt=. (0,cnt) validate_data__c >i{vs
end.
+/-.dat__active__t
)

NB. Insert__d has a number of problems - e.g. shape mismatch damages a table
NB. api insert has extra validations/retrictions and gives better error messages
NB. missing/unknown/duplicate cols
NB. bad count/shape/data
NB. date/time must be integer
NB. date/time not allowed trailing shape
jd_insert=: 3 : 0
FETAB=: ;{.y
d=. getdb''
nv=. vsub 1}.y
n=. nv validateinsert ;{.y

r=. insertptable nv
if. -.''-:r do. r return. end.

Insert__d  ({.y),<nv
t=. getloc__d ;{.y
n=. n-~+/-.dat__active__t
if. 0~:n do.
 0 assert~EUNIQUE rplc 'N';":n
end.
JDOK
)

insertptable=: 3 : 0
tab=. FETAB
t=. jdgl_jd_ :: 0: tab,PTM
if. 0=t do. '' return. end. NB. return to do normal read
pcol=. getpcol__t''
c=. {:CHILDREN__t
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
  jd_insert (tab,PTM,dtb":;part);,d
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
s=. {:jd_info'schema ',tab
for_i. i.ttally s do.
 d=. i tfrom s
 n=. }.d
 shape=. ;{:d
 shape=. ;(shape=_){shape;''
 d=. (<(;{.d),PTM,part),(1{d),<(;2{d),' ',":shape
 jd_createcol d
end.
s=. {:jd_info'dynamic ',tab
for_i. i.ttally s do.
 d=. i tfrom s
 t=. (;{.d),PTM,part
 a=. <;.1 ' ',(2}.;}.d)rplc'_';' '
 ('jd_',}.;{.a)~ t,;}.a
end.
i.0 0
)

jd_delete=: 3 : 0
y=. bdnames y
FETAB=: ;{.y
ECOUNT assert 2=#y
r=. deleteptable y
if. -.''-:r do. r return. end.
d=. getdb''
Delete__d y
JDOK
)

deleteptable=: 3 : 0
t=. jdgl FETAB
if. -.S_ptable__t do. '' return. end.
t=. jdgl FETAB,PTM
pcol=. getpcol__t''
w=. ;}.y
set=. (FETAB,' ',pcol)get_jdquery_ w NB. from readptable
p=. (<FETAB),each PTM,each set
p=. (<"0 p),each <<w
jd_delete each p
JDOK
)

jd_update=: 3 : 0
ECOUNT assert 2<:#y
'tab w'=. 2{.y
FETAB=. tab
new=. vsub 2}.y
t=. jdgl tab
n=. NAMES__t
n=. n#~-.(<'jd')=2{.each n
n=. n-.{."1 new
if. 0~:#n do.
 new=. new,old=. jd_read (}:;n,each','),' from ',tab,' where ',w
end. 
new validateinsert tab NB.insert must succeed - bacause deletes have been done
jd_delete tab;w NB. recalcs where, but that inefficiency is probably ok for now
jd_insert tab;,new
JDOK
)

NB. explicit index for deleted row is allowed
jd_modify=: 3 : 0
ECOUNT assert 2<:#y
'tab w'=. 2{.y
FETAB=. tab
nv=. vsub 2}.y
t=. jdgl tab
n=. NAMES__t
n=. n#~-.(<'jd')=2{.each n
n=. n-.{."1 nv

ns=. {."1 nv
vs=. {:"1 nv
all=. ((<'jd')~:2{.each NAMES__t)#NAMES__t NB. all col names
unknown_assert ns-.all
duplicate_assert ns

if. 2=3!:0 w do.
 w=. ;{:,old=. jd_read'jdindex from ',tab,' where ',w
else.
 if. 4~:3!:0 w do. NB. see fixtype_num_jdtint_
  if. 1=3!:0 w do. w=. 0+w else. EINDEX assert 0 end.
 end.
 w=. ,w
end.

for_i. i.#ns do. NB. validate
 c=. getloc__t {.i{ns
 assertnodynamic NAME__PARENT__c;NAME__c
 (1,#w) validate_data__c >i{vs 
end.

pt=. jdgl_jd_ :: 0: tab,PTM
if. 0=pt do.
 for_i. i.#ns do.
  c=. getloc__t {.i{ns
  w modify__c >i{vs
 end.
else.
 NB. part modify
 'parts tlens'=. getparts tab
 EINDEX assert (w<+/tlens),0<:w
 base=. 0,}:+/\tlens
 i=. <:0 i.~"0 1 w >/ base
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
