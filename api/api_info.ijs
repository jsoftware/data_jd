NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. api extension (keep apl.ijs core smaller

coclass'jd'

jd_list=: 3 : 0
t=. bdnames y
ECOUNT assert 1=#t
select. ;t
case. 'version' do. jdversion
case. 'open'    do. ,.'open';<>opened''
case.           do. assert 0['unsupported list command'
end. 
)

jd_info=: 3 : 0
t=. bdnames y
a=. 2{.}.t
select. {.t
case. 'agg' do.
 d=. getdb''
 ,.'aggs';>{."1 AGGFCNS__d
case. 'last' do.
 ,.(;:'cmd time space parts'),:(,:lastcmd);lasttime;lastspace;lastparts
case. 'schema' do.
 infoschema a
case. 'summary' do.
 infosummary a
case. 'table' do.
 infotable a
case. 'validate' do.
 infovalidate a
case. 'validatebad' do.
 infovalidatebad a
case. 'varbyte' do.
 infovarbyte a
case. 'ref' do.
 'ref' infox a
case. do.
 'unsupported info command'assert 0
end. 
)

getinfoclocs=: 3 : 0
if. -.''-:;{.y do. jdclocs y return. end.
n=. /:~NAMES__dloc
n=. n#~-.;PTM e.each n
r=. ''
for_a. n do.
 r=.r,jdclocs a,<''
end. 
)

infotable=: 3 : 0
d=. getdb''
t=. ;{.y
n=. /:~NAMES__d
if. 0~:#t do.
 if. (PTM,'*')=_2{.t do.
  n=. getparttables _2}.t
  'not a ptable' assert 1<#n
 else.
  'not a table'assert (<t)e.n  
  n=. <t
 end. 
else.
 n=. n#~-.;PTM e.each n
end. 
,.'table';>n
)

fromclocs=: 4 : 0"1 0
<(x,'_','_',~;y)~
)

pfromclocs=: 3 : 0"0
a=. ('PARENT_','_',~;y)~
<NAME__a
)

infox=: 4 : 0
locs=. getinfoclocs y
ts=. cs=. 0 0$''
for_c. locs do.
 if. (('jd'-:2{.NAME__c)*.x-:'')+.x-:typ__c do.
  t=. PARENT__c
  ts=. ts,NAME__t
  cs=. cs,NAME__c
 end. 
end.
s=. /:ts,.cs
ts=. s{ts
cs=. s{cs
(;:'table column'),:ts;cs
)

infoschema=: 3 : 0
locs=. getinfoclocs y
ts=. cs=. typ=. shape=. 0 0$''
for_c. locs do.
 if. -.'jd'-:2{.NAME__c do.
  t=. PARENT__c
  ts=. ts,NAME__t
  cs=. cs,NAME__c
  typ=. typ,typ__c
  shape=. shape,;(0=#shape__c){shape__c;_
 end. 
end.
(;:'table column type shape'),:ts;cs;typ;shape
)

infovalidate=: 3 : 0
''validateclocs jdclocs y
)

infovalidatebad=: 3 : 0
d=.''validateclocs jdclocs y
b=. ' '~:,;2{{:d
({.d),:(<b)#each {:d
)

infovarbyte=: 3 : 0
locs=. getinfoclocs y
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

infoad=: 3 : 0
t=. getloc__dloc y
Tlen__t
)

infosummary=: 3 : 0
d=. getdb''
t=. ;{.y
if. (PTM,'*')=_2{.t do.
 ts=. getparttables _2}.t
 'not a ptable' assert 1<#ts
 r=. ;infoad each ts
 n=. (<>ts),<,.r
else.
 ts=. /:~NAMES__d
 if. 0=#ts do. (;:'table rows'),:3#<(0 0$'') return. end.
 if. -.''-:t do.
  'not a table'assert NAMES__d e.~ <t
  tloc=. jdgl t
  if. S_ptable__tloc do.
   ts=. ts#~(<t)=(#t){.each ts
   ts=. ts#~PTM~:;{:each ts
   r=. ;infoad each ts
   n=. (<t),<,.+/r
  else.
   ts=. ((<t)=(#t){.each ts)#ts
   r=. ;infoad each ts
   n=. (>ts);<,.r
   n=. (<,:t),,.each<"0 infoad t
  end. 
 else.
  ts=. ts#~PTM~:;{:each ts
  r=. ;infoad each ts
  q=. dtb each (;ts i. each PTM){.each ts,each' '
  i=. (<"1=q)#each <i.#ts
  a=. ;+/each i{each <r 
  n=. (>({.each i){q);<,.a
 end. 
end.
(;:'table rows'),:n
)

statefmt=: 3 : 0
({."1 y)=. {:"1 y
typ,' ',deb ,sptable subscriptions
if. 1=#subscriptions do.
 deb ,sptable subscriptions
else.
 (deb ,sptable {.subscriptions),' > ',deb ,sptable {:subscriptions
end.
)