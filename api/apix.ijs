NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. api extension (keep apl.ijs core smaller

coclass'jd'

jd_list=: 3 : 0
t=. bdnames y
ECOUNT assert 1=#t
select. ;t
case. 'version' do. ,.'version';'2.2.1'
case. 'open'    do. ,.'open';<>opened''
case.           do. assert 0['unsupported list command'
end. 
)

jd_info=: 3 : 0
t=. bdnames y
a=. 2{.}.t
select. {.t
case. 'table' do.
 infotable''
case. 'schema' do.
 infoschema a
case. 'last' do.
 ,.(;:'cmd time space'),:(,:lastcmd);lasttime;lastspace
case. 'varbyte' do.
 infovarbyte a
case. 'summary' do.
 infosummary a
case. 'unique' do.
 'unique' infox a
case. 'hash' do.
 'hash' infox a
case. 'ref' do.
 'ref' infox a
case. 'reference' do.
 'reference' infox a
case. 'agg' do.
 d=. getdb''
 ,.'aggs';>{."1 AGGFCNS__d 
case. do.
 'unsupported info command'assert 0
end. 
)

infotable=: 3 : 0
 d=. getdb''
 ,.'table';>/:~ NAMES__d
)

fromclocs=: 4 : 0"1 0
<(x,'_','_',~;y)~
)

pfromclocs=: 3 : 0"0
a=. ('PARENT_','_',~;y)~
<NAME__a
)

infox=: 4 : 0
locs=. jdclocs y
ts=. cs=. 0 0$''
for_c. locs do.
 if. x-:typ__c do.
  t=. PARENT__c
  ts=. ts,NAME__t
  cs=. cs,NAME__c
 end. 
end.
(;:'table column'),:ts;cs
)

infoschema=: 3 : 0
locs=. jdclocs y
ts=. cs=. typ=. shape=. 0 0$''
for_c. locs do.
 if. -.'jd'-:2{.NAME__c do.
  t=. PARENT__c
  ts=. ts,NAME__t
  cs=. cs,NAME__c
  typ=. typ,typ__c
  shape=. shape,shape__c
 end. 
end.
(;:'table column type shape'),:ts;cs;typ;shape
)

infovarbyte=: 3 : 0
locs=. jdclocs y
ts=. cs=. 0 0$''
r=. 0 3$0
for_c. locs do.
 if. 'varbyte'-:typ__c do.
  t=. PARENT__c
  ts=. ts,NAME__t
  cs=. cs,NAME__c
  getloc__t NAME__c NB. map as required
  t=. {:"1 dat__c
  r=. r,(<./t);(<.(+/t)%#t);>./t
 end. 
end.
(;:'table column min avg max'),:ts;cs;(,.>0{"1 r);(,.>1{"1 r);,.>2{"1 r
)

infosummary=: 3 : 0
d=. getdb''
ts=. /:~ NAMES__d
r=. 0 2$''
for_t. ts do.
 t=. getloc__d ;t
 c=. getloc__t 'jdactive'
 a=. +/dat__c
 b=. (#dat__c)-a
 r=. r,a,b
end.
(;:'table active deleted'),:(>ts);(,.>0{"1 r);,.>1{"1 r
)

statefmt=: 3 : 0
({."1 y)=. {:"1 y
typ,' ',deb ,showbox subscriptions
if. 1=#subscriptions do.
 deb ,showbox subscriptions
else.
 (deb ,showbox {.subscriptions),' > ',deb ,showbox {:subscriptions
end.
)
