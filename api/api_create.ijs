NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

coclass'jd'

jd_createdb=: 3 : 0
ECOUNT assert 0=#y
t=. dbpath DB
'w'jdadminlk t
'f db'=. getfolder''
Create__f db
JDOK
)

jd_createtable=: 3 : 0
if. 0=L.y do. NB. string parse has , and LF in col defs
 a=. bdnames y
 y=. ''
 if. '/a'-:;{.a do.
  y=. 4{.a
  a=. 4}.a
 end.
 y=. y,{.a NB. table name
 a=. }.a
 NB. y=. y,<;' ',each a
 y=. y, a:-.~<;._2 LF,LF,~(;a,each' ')rplc',';LF
end. 
a=. '/types 0 /pairs 0 /a 3'getoptionsx y

df=. option_pairs
if. 3=#option_a do.
 EALLOC assert 0<option_a
 alloc=. 4 1 1>.option_a
else. 
 alloc=. ROWSMIN_jdtable_,ROWSMULT_jdtable_,ROWSXTRA_jdtable_
end.
vtname FETAB=: t=. >0{a NB. table
a=. }.a

if. df do.
 a=. ,a
 'name data pairs - odd number' assert (2<:#a)*.0=2|#a
 names=. ,each(2*i.-:#a){a
 names=. names rplc each <'.';'__'
 data=. (>:2*i.-:#a){a
 if. option_types do.
  '(type) missing from names'assert ')'=;{:each names
  i=. ;names i:each '('
  typ=. }:each (>:i)}.each names
  names=. i{.each names
  tshape=. ":each}.each$each data
  m=. (typ e. ;:'edate edatetime edatetimem edatetimen')#i.#typ
  tshape=. (<'') m}tshape
 else.
  typ=. jdtypefromdata each data
  tshape=. ":each}.each$each data
 end. 
 a=. names,each' ',each typ,each ' ',each tshape
end.

a=. ;cutcoldefs each a
if. #a do.
 b=. ><;._2 each a,each' '
 ns=. 0{"1 b
 ts=. 1{"1 b
 vcname each ns
 duplicate_assert ns
 ETYPE assert ts e.TYPES
 if. 3<:{:$b do. NB. have shapes
  EBTS assert 3={:$b
  ss=. 2{"1 b
  for_i. i.#ns do.
   FECOL_jd_=: ;i{ns
   s=. ;i{ss
   if. 0~:#s do. NB. this quy has a shape
    s=. _1".s
    EBTS assert ('byte'-:;i{ts),(_1~:s),1=#s
   end. 
  end.
 end. 
end.
a=. }:;a,each','
d=. getdb''
Create__d t;a;'';alloc   NB. cols;data;alloc
if. df do.
 try.
  jd_insert FETAB;,names,.data
 catchd.
  jd_droptable FETAB
  rethrow''
 end. 
end.
JDOK
)

jd_createptable=: 3 : 0
a=. bdnames y
ECOUNT assert 2=#a
'tab col'=: a
d=. getdb''
'not a table'assert NAMES__d e.~<tab
t=. jdgl tab
'not empty'assert 0=Tlen__t
'already a ptable'assert 0=S_ptable__t
c=. jdgl tab,' ',col
'bad col type'assert (<typ__c) e. ;:'int edate edatetime date datetime'
S_ptable__t=: 1
writestate__t''
jd_createtable tab,PTM
jd_createcol tab,PTM,' ',col,' ',typ__c,' ',":shape__c
JDOK
)

NB. not boxed -> no dat : boxed -> dat
NB. createcol done with default data and then update with col data
jd_createcol=: 3 : 0
d=. getdb''
if. 1<:L.y do.
 NB. boxed assumes has dat
 dat=. >{:y  NB. col values
 y=. }:y
else.
 dat=. ''
 y=. bdnames y
end.
FETAB=: ;0{y
FECOL=: ;1{y
vcname FECOL
if. 4=#y do.
 if. (,'_')-:;3{y do. y=. }:y end.
else.
 ECOUNT assert 3=#y
end.

if. 4=#y do. EBTS assert (2{y)-:<'byte' end.

if. #dat do. NB. have column values
 t=. getloc__d FETAB
 'ptable data not allowed'assert 0=S_ptable__t
 if. (0=Tlen__t)*.0=#NAMES__t#~;(<'jd')~:2{.each NAMES__t do. setTlen__t #dat end.
end.

ns=. getparttables ;{.y
for_i. i.#ns do.
 if. i=1 do. continue. end. NB. ignore f~
 InsertCols__d (i{ns),< ;' ',~each}.":each y
end.

if. #dat do.
 try.
  jd_update FETAB;_;FECOL;dat 
 catch.
  e=. 13!:12''
  jd_dropcol FETAB;FECOL
  e assert 0
 end. 
end.
JDOK
)
