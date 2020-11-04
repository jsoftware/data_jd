NB. Copyright 2016, Jsoftware Inc.  All rights reserved.

coclass'jd'

readstart=: 3 : 0
if. 0~:L.y do. y=. ;y[ECOUNT assert 1=#y end.
'/lr 0 /e 0 /types 0 /table s /file s'getopts y
)

NB. jdi ops allow manageing state before and after an internal call
jdi_read=: 3 : 0
jd_read y
)

NB. jdi ops allow manageing state before and after an internal call
jdi_reads=: 3 : 0
jd_reads y
)

jd_read=: 3 : 0
jd_reads '/lr ',y
)

jd_reads=: 3 : 0
NB. erase globals from last read - previously done with coerase of jdquery temporary locale
NB. some globals left as they are used in readptable loop
erase__dbl;:'cnms read inds' 
if. 0~:L.y do. y=. ;y[ECOUNT assert 1=#y end.
y=. '/lr 0 /e 0 /types 0 /table s /file s'getopts y
if. 0~:option_table do.
 ETABLEFILE assert 0=option_file
 option_lr=: 1
 option_types=: 1
 vtname option_table
 i=. dbrow DBOPS
 'must be able to createtable'assert +./('createtable';,'*')e.bdnames>{:i{DBOPS
end. 

if. 0~:option_file do.
 ETABLEFILE assert 0=option_table
 file=. PATH__dbl,'jdfile/'
 if. -.fexist file do.
  jdcreatefolder file
 'file'fwrite file,'jdclass'
 end.
end.

r=. readptable y
if. ''-:r do.
 if. option_lr do.
 r=. Read__dbl y
 else. 
 r=. Reads__dbl y
 end.
end. 
if. 0~:option_table do.
 FETAB=: option_table
 jd_createtable '/pairs';'/types';'/replace';option_table;,r
 JDOK
elseif. 0~:option_file do.
 (3!:1 r)fwrite file,option_file
 JDOK
elseif. 1 do. 
 r
end. 
)

NB. convert partition read where clause to refer only to ptable
pump=: 4 : 0
t=. <x
if. 0=L. y do. y return. end.
if. 2=L. y do.
 if. (<'qnot')={.y do.
  if. t~:{.;}.y do.
   <x;'jdqpall';'1'
  else.
   y
  end. 
 else.
  if. t~:{.;y do.
   <x;'jdqpall';'1'
  else.
   y
  end.
 end.
else. 
 t pump each y
end. 
)

NB. 'table pcol' get where_clause
get=: 4 : 0
'tab pcol'=. ;:x
t=. jdgl_jd_ tab,PTM
c=. jdgl_jd_ tab,PTM,' ',pcol
jdqpall__c=: 3 : 'i.countdat dat'
s=. forcecopy dat__c
if. -.''-:y do.
 r=. (<t) eval_q_jdquery_ each pcol pump toSoP_jdquery_ fixwhere_jdtable_ y
 i=. /:~~._1-.~;r
 s=. i{s
end.
typ__c pcol_ffromv_x s
)

readptable=: 3 : 0
'sel by from where order'=. sel_parse_jdquery_ y
exact=. 'exact '-:6{.from
if. exact do. from=. 6}.from end.
'alias root'=. dltb each 2$<;._2 ':',~;{.<;._2 from,','
NB. check if first table is root and is partitioned table
if. -.isptable root do. '' return. end. NB. return to do normal read
t=. jdgl_jd_ :: 0: root,PTM
pcol=. getpcol__t''
from=. (from i.',')}.from

NB.! change to OP is bad - so use another flag
OP_jd_=: 'readptable' NB. kludge flag to SelBy for automatic count agg and autoindex 
optlr=: option_lr
NB. build read arg (order stripped out to be done at end)
a=. <((0~:#sel)#sel,' '),((0~:#by)#'by ',by,' '),'from ',(exact#'exact '),alias,':'
b=. <from,' where ',where
set=. (root,' ',pcol)get where
parts=: #set
if. 0=parts do. '' return. end. NB. empty result - just do it on empty base table
p=. (<root),each PTM,each set
('no table:',;' ',each p-.NAMES__dbl) assert 0=#p-.NAMES__dbl
z=. a,each p,each b
r=. 0
for_i. i.#z do.
 FETAB=: ;i{p
 a=. jdi_read ;i{z
 d=. {:"1 a
 t=. ;i{set
 sc=. <((#>{.d),#t)$t
 if. 0=r do.
  h=. ,.{."1 a
  hs=. 1,~#h
  r=. sc,d
 else.
  'table partitions not conformable'assert h-:,.{."1 a
  r=. r,&.>sc,d
 end. 
end. 
if.  a:~:{.AGG_jd_ do.
 if. (<'avg')e. AGG do.
  i=. AGG i. <'count'
  COUNT=: ,>i{}.r
 end.
 bys=. (_1+#r)-#AGG
 if. 0=bys do.
  r=. h,.hs$AGG agg each }.r
 else.
  by=. bys{.}.r 
  NB. r=. h,.hs$(ifa~.afi by),by setaggby (1+bys)}.r
  r=. h,.(ifa~.afi by),by setaggby (1+bys)}.r 
 end. 
else.
 r=. h,.hs$}.r
end.

if. 0~:#order-.' ' do.
 NB. order by clause - use jdquery locale rather than a temp locale that is coerased 
 cnms_jdquery_=: {."1 r
 read_jdquery_=: {:"1 r
 Order_jdquery_ order
 r=. cnms_jdquery_,.hs$read_jdquery_
 erase'cnms_jdquery_';'read_jdquery_'
end.

if. 'readtsetautocount'-:;{:{."1 r do. r=. }:r end. NB. done after oder by

if. -.optlr do.
 r=. ({."1 ,: [:tocolumn{:"1)r
end.
r
)

setaggby=: 4 : 0
byx=. afi x
nub=. ~.byx
r=. (#y)$<0 0$''
while. #nub do.
 a=. *./"1 byx="1{.nub
 nub=. }.nub
 d=. (I.a) tfrom y
 if. 1=+/a do.
  r=. r,&.>d
 else.
  if. (<'avg')e. AGG do.
   i=. AGG i. <'count'
   COUNT=: ,>i{d
  end.
  r=. r,&.>AGG agg each d
 end. 
end.
,each r
)

NB. aggregation for simple sets (no by clause)
agg=: 4 : 0
select. x
case. 'avg' do.
 ,.(+/COUNT*,y)%+/COUNT
case. 'count' do.
 ,.+/y
case. 'first' do.
 t=. {.y
 (1,$t)$t
case. 'last' do.
 t=. {:y
 (1,$t)$t
case. 'max' do.
 >./y
case. 'min' do.
 <./y
case. 'sum' do.
 ,.+/y
case. do.
 'unsupported aggregation'assert 0
end.
)

