NB. Copyright 2014, Jsoftware Inc.  All rights reserved.
NB. api extension (keep apl.ijs core smaller

coclass'jd'

jd_list=: 3 : 0
t=. bdnames y
ECOUNT assert 1=#t
select. ;t
case. 'version' do. jdversion
case.           do. assert 0['unsupported list command'
end. 
)

NB. jdi ops allow manageing state before and after an internal call
jdi_info=: 3 : 0
jd_info y
)

jd_info=: 3 : 0
t=. bdnames y
a=. 2{.}.t
select. {.t
case. 'agg' do.
 ,.'aggs';>{."1 AGGFCNS__dbl
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
 'ref' inforef a
case. 'derived' do.
 infoderived a
case. 'blob' do.
 infoblob a
case. do.
 'unsupported info command'assert 0
end. 
)

getinfoclocs=: 3 : 0
if. -.''-:;{.y do. jdclocs y return. end.
n=. /:~NAMES__dbl
n=. n#~-.;PTM e.each n
r=. ''
for_a. n do.
 r=.r,jdclocs a,<''
end. 
)

infotable=: 3 : 0
t=. ;{.y
n=. /:~NAMES__dbl
if. 0=#n do.
 'invalid table arg'assert 0=#t
 ,.'table';0 0$''
 return.
end.
if. 0~:#t do.
 if. -.(PTM,'*')-:_2{.t do. 'not a ptable' assert 0 end.
  n=. getparttables _2}.t
  'not a ptable' assert 1<#n
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

inforef=: 4 : 0
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
''validateclocs 1 jdclocs y
)

infovalidatebad=: 3 : 0
d=.''validateclocs 1 jdclocs y
b=. ' '~:,;2{ {:d
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

infoderived=: 3 : 0
locs=. getinfoclocs y
ts=. cs=. vs=. 0 0$''
r=. 0 3$0
for_c. locs do.
 if. derived__c +. derived_mapped__c do.
  t=. PARENT__c
  ts=. ts,NAME__t
  cs=. cs,NAME__c
  vs=. vs,dverb__c
 end. 
end.
(;:'table column verb'),:ts;cs;vs
)

infoblob=: 3 : 0
d=. dirtree (dbpath_jd_ DB_jd_),'/*.blob'
if. 0=#d do. (;:'name date size'),:3#<0 0$'' return. end.
n=. {."1 d
n=. _5}.each (#jpath dbpath_jd_ DB_jd_)}.each n
n=. }.each ;each (<;.1 each n)-.each <<'/jdblob'
n=. >n rplc each <'/';' '
ts=. >isotimestamp each 1{"1 d
size=. ,.>2{"1 d
(;:'name date size'),:n;ts;size
)

infoad=: 3 : 0
t=. getloc__dbl y
Tlen__t
)

infosummary=: 3 : 0
t=. ;{.y
ts=. /:~NAMES__dbl
if. 0=#ts do.
 'invalid table arg'assert 0=#t
 (;:'table rows'),:2#<(0 0$'')
 return.
end.
if. (PTM,'*')=_2{.t do.
 ts=. getparttables _2}.t
 'not a ptable' assert 1<#ts
 r=. ;infoad each ts
 n=. (<>ts),<,.r
else.
 if. -.''-:t do.
  'not a table'assert NAMES__dbl e.~ <t
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
