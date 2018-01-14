NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

coclass'jd'

jd_sort=: 3 : 0
a=. '/desc 0'getoptions y
ECOUNT assert 2<:#a
FETAB=: tab=: ;{.a
d=. getdb''
1 validtc__d a
d=. getdb''
a=. stitch__d tab;<}.a
if. option_desc do. s=. \:a else. s=. /:a end. 
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
 dat__c=: s{dat__c
end.  
JDOK
)