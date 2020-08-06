NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

coclass'jd'

jd_createdb=: 3 : 0
ECOUNT assert 0=#y
t=. dbpath DB
'w'jdadminlk t
'f db'=. getfolder''
Create__f db
getdb'' NB. required for new db
JDOK
)

NB. careful: /replace option used in multiple ops
jd_createtable=: 3 : 0
a=. '/replace 0 /types 0 /pairs 0 /a a'getopts y
if. 0=L.a do. NB. string has col defs with commas and blanks
 a=. dlb a
 i=. a i.' '
 FETAB=. i{.a
 cds=. cutcoldefs i}.a
else.
 FETAB=: ;{.a
 a=. }.a
 NB. a could be col defs or could be pairs
 if. option_pairs do.
  cds=. ''
 else. 
  if. 1=#a do.
   cds=. cutcoldefs ;a
  else. 
   cds=. 3{.each bdnames each a NB. assume boxed coldefs without , or LF
  end. 
 end.
end.
vtname FETAB
if. 3=#option_a do.
 EALLOC assert 0 0 _1<option_a
 alloc=. 4 1 0>.option_a
else. 
 alloc=. ROWSMIN_jdtable_,ROWSMULT_jdtable_,ROWSXTRA_jdtable_
end.
if. option_pairs do.
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
  i=. typ i. each ' '
  tshape=. ":each 0".each i}.each typ
  typ=. i{.each typ
 else.
  typ=. jdtypefromdata each data
  tshape=. ":each}.each$each data
 end. 
 cds=. <"1 names,.typ,.tshape
end.

if. #cds do.
 ns=. >0{each cds
 ts=. >1{each cds
 ss=. >2{each cds
 vcname each ns
 duplicate_assert ns
 ETYPE assert ts e.TYPES
 b=. -.a:=ss
 EBTS assert (<'byte')=b#ts
 EBTS assert _1~:;_1".each b#ss
end.

if. option_replace do. jd_droptable FETAB end.

Create__dbl FETAB;'';'';alloc   NB. cols;data;alloc

t=. getloc__dbl FETAB
for_d. cds do.
 d=. >d
 ICol__t  ({.d),<;' ',~each  1}.d
end.

if. option_pairs do.
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
'not a table'assert NAMES__dbl e.~<tab
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
if. 1<:L.y do.
 NB. boxed assumes has dat
 dat=. >{:y  NB. col values
 y=. }:y
else.
 dat=. ''
 y=. '/derived 0 /derived_mapped 0' getopts bdnames y
 if. option_derived        do. createdcol  y return. end.
 if. option_derived_mapped do. createdmcol y return. end.
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
 t=. getloc__dbl FETAB
 'ptable data not allowed'assert 0=S_ptable__t
 if. (0=Tlen__t)*.0=#NAMES__t#~-.bjdn NAMES__t do. setTlen__t #dat end.
end.

ns=. getparttables ;{.y
for_i. i.#ns do.
 if. i=1 do. continue. end. NB. ignore f~
 t=. getloc__dbl i{ns
 ICol__t  FECOL;;' ',~each  2}.y
end.

if. #dat do.
 if. 1=L. dat do. dat=. <dat end. NB. assume boxed is varbyte 
 try.
  jd_update FETAB;_;FECOL;dat NB. varbyte bug - needs <
 catch.
  e=. 13!:12''
  jd_dropcol FETAB;FECOL
  e assert 0
 end. 
end.
JDOK
)


NB.!!! duplicate code from jd_createcol should be factored out
createcol=: 3 : 0
FETAB=: ;0{y
FECOL=: ;1{y
vcname FECOL
if. 4=#y do.
 if. (,'_')-:;3{y do. y=. }:y end.
else.
 ECOUNT assert 3=#y
end.
if. 4=#y do. EBTS assert (2{y)-:<'byte' end.
ns=. getparttables ;{.y
for_i. i.#ns do.
 if. i=1 do. continue. end. NB. ignore f~
 t=. getloc__dbl i{ns
 ICol__t  FECOL;;' ',~each  2}.y
end.
)

jd_createdcol=: 3 : 0    NB. deprecated
jd_createcol '/derived ',y
)

createdcol=: 3 : 0
v=. ;{:y NB. verb
q=. }:y
assertnotptable {.q
createcol q
c=. jdgl 2{.q
derived__c=: 1
dverb__c=: 'derived_',v
writestate__c'' 
jdunmap 'dat',Cloc__c
ferase PATH__c,'dat'
erase 'dat'
JDOK
)

NB. col_name jddmfrom base_data_pairs - data_pairs have the col_name data
NB. col_name jddmfrom rows            - rows selected from col_name dat 
NB. run in col locale
jddmfrom=: 4 : 0
if. 0=L. y do.
 c=. getloc__PARENT x
 y{dat__c
else.
 if. 1=$$y do.  y=. _2 ]\y end.
 >{:(({."1 y)i.<,x){y
end.
)

NB. bdnames arg
createdmcol=: 3 : 0
v=. ;{:y NB. verb
q=. }:y
assertnotptable {.q
createcol q
c=. jdgl 2{.q
derived_mapped__c=: 1
dverb__c=: 'derived_mapped_',v
writestate__c''

if. #dat__c do. NB. update dm col
 rows=. i.#dat__c
 rows modify__c fixtypex__c (dverb__c,'__c')~ rows
end. 

JDOK
)
