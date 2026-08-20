NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

coclass'jd'

NB. based on Order in read.ijs
jd_sort=: 3 : 0
if. 1=L. y do.
 ECOUNT assert 2=#y
 'tab ord'=. y
else.
 y=. deb y
 i=. y i. ' '
 tab=. i{.y
 ord=. i}.y
end.
FETAB=: tab
ord=. cutcommas ord
if. 0 = #ord do. JDOK return. end.
ifdesc=. (<'desc') = _4 {.&.> ord
ord=. jdremq each ifdesc (_4 stripsp@}. ])^:[&.> ord
'duplicate col'assert (#ord)=#~.ord
1 validtc__dbl (<FETAB),ord
q=. ''
for_n. ord do.
 c=. jdgl tab;n
 q=. q,<dat__c
end. 
q=. q,<i.#>{.q
ndx=. i.#ord
for_nd. |. ndx,.ifdesc do.
  'n d'=.nd
  q=. q {&.>~ < /:`\:@.d n{::q
end.
s=. >{:q
if. s-:i.#s do. JDOK return. end.
t=. jdgl tab
update_subscr__t''
for_c. CHILDREN__t do.
 select. typ__c
 case.'autodindex' do. continue.
 case.'ref' do.
  if. dirty__c do. continue. end.
  if. left__c  do. setdirty__c 1 continue. end. NB. could handle this
 end.
 if. derived__c do. setderiveddirty__c'' else. dat__c=: s{dat__c end. 
end.  
JDOK
)
