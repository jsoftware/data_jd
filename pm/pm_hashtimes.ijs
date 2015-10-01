NB. Copyright 2015, Jsoftware Inc.  All rights reserved.

0 : 0
create hash uses lots of ram and updates random locations
thrash if there is not enough ram
create can take 10 or more times as long to complete if too little ram

create hash is done explicitly (jd'createhash ...')
and implicility if a resize is required

unique is the same except less ram is required as there is no link

create/resize hash is done with temporary data in H data (ui32)  
this reduces ram required and allows faster hash of many rows

hash of int col with r million rows done with I data reguires ram:
 r*8  - gb for col data
 r*16 - hash col has twice as many rows
 r*8  - link col
 ___
 r*32 - gb required to do hash in I
 
hash done with H:
 r*8  - gb for col data
 r*8  - hash col has twice as many rows
 r*4  - link col
 ___
 r*20 - gb required to do hash in H
 
not a big difference, but perhaps enough to remove hash from being a performance contraint

win7/6gb (assume 5gb usable after os/j/jd):
 200e6 rows - hash of int col
 H hash requires 4   gb (200*20)
 I hash requires 6.4 gb
 
 H hash takes 2.3  mins
 I hash takes 21.3 mins (thrash)
 
 in general Jd performs best when there is ram for at least 3 times the size of an int col
 3*8*200e6 is under 5gb
 ram requirements for H hash of 200e6 int col matches general jd ram requirements
 
 
linux/24gb (assume 23gb usable after os/j/jd):
 1000e6 rows - hash of int col
 H hash requires 20 gb (1000*20)
 I hash requires 32 gb
 
 H hash takes 7.8 mins
 I hash takes 24  mins (thrash)
 
 3*8*1000e6 is 24gb
 ram requirements for H hash of 1000e6 in col matches general jd ram requirements
 
)

0 : 0
hash create uses H hash except for varbyte or enum cols

variables allow using different hash routines for timing

HASHFAST 1 uses H and 0 uses I to create/resize hash

HASHCREATE32BIT_jd_=: 0
HASHPASSLEN_jd_=: <.2^29




)

cr_admin=: 3 : 0
jdadmin'~temp/jdpm/','d',tn y
)

tn=: 3 : 0
;(y>:1e6){(":y);(":<.y%1e6),'e6'
)

cr_adminx_x=: 3 : 0
jdcreatefolder_jd_'~temp/jdpm'
jdadminx'~temp/jdpm/','d',tn y
)


NB. create tables for preformance tests
NB. cr    10 - create table h10    with    10 rows
NB. cr 100e6 - create table h100e6 with 100e6 rows
acr=: 3 : 0
n=. y
jdadmin 0
jdadminx'~temp/jdpm/','d',tn y
pmclear_jd_''
jd'createtable f'
a=. 13*i.n
b=. 89*i.1000<.-:n
jd'createcol f a  int _';a
jd'createcol f b  int _';n$b

jd'createtable g'
jd'createcol g a  int _';|.a

jd'createtable h'
jd'createcol h b  int _';|.b

pmr_jd_''
)

aadmin=: 3 : 0
t=. 'd',tn y
jdadmin'~temp/jdpm/',t
)

areference=: 3 : 0
pmclear_jd_''
jd'dropdynamic'
jd'createunique f a'
jd'createunique g a'
jd'createhash   f b'
jd'createunique h b'

jd'reference f a g a'
jd'reference f b h b'
pmr_jd_''
)

aref=: 3 : 0
pmclear_jd_''
jd'dropdynamic'
jd'ref f a g a'
jd'ref f b h b'
pmr_jd_''
)

ard=: 3 : 0
s=. 'reads from f,f.g where jdindex<5'
decho s
decho jd s
s=. 'reads from f,f.h where jdindex<5'
decho s
decho jd s
s=. 'reads from f,f.g,f.h where jdindex<5'
decho s
decho jd s
)

cruu=: 3 : 0
pmclear_jd_''
n=. y
d=. 13*i.n
f=. 'f',tn y
jd'droptable ',f
jd'createtable ',f
jd('createcol ',f,' a int _');d
jd('createcol ',f,' b int _');d
g=. 'g',tn y
jd'droptable ',g
jd'createtable ',g
jd('createcol ',g,' a int _');|.d
jd('createcol ',g,' b int _');|.d
jd'createunique ',f,' a'
jd'createunique ',g,' a'
jd'reference ',f,' a ',g,' a'
)

NB. create tables for createhash with limited nub
cr_limited=: 3 : 0
n=. y
t=. 'hnub',tn y
jd'droptable ',t
jd'createtable ',t
jd('createcol ',t,' a int _');13*i.n
jd'close'
jd('createcol ',t,' b int _');n$89*i.(n>20000){5 20000
t=. t,'x'
jd'droptable ',t
jd'createtable ',t
jd('createcol ',t,' a int _');i.(n>20000){5 20000
jd'close'
jd('createcol ',t,' b int _');89*i.(n>20000){5 20000
jd'close'
)




hlget=: 4 : 0
if. -.x do. '' return. end.
h=. jdgl_jd_ y
hash=. forcecopy_jd_ hash__h
link=. forcecopy_jd_ link__h
'bad link' assert _1=link
hash;link
)

PAUSE=: 0

PASS=: <.2^29
TV=:    'HASHFAST_jd_ HASHPASSLEN_jd_'
TVX=: 0 : 0
h    1 0
pass 0 1
i    0 0
)

a=. <;._2 TVX
i=. a i. each ' '
TYPES=: i{.each a
V=: >0".each(>:each i)}.each a

jdx=: 3 : 0
r=. jdt y
a=. ;:y

if. 50e6>:0".}.;1{a do.
 decho 'do compares'
 if. 'createhash'-:;{.a do.
  a=. (;1{a),' jdhash',;'_',each 2}.a
  h=. jdgl_jd_ a
  if. hl-:'' do.
   hl=: (forcecopy_jd_ hash__h);(forcecopy_jd_ link__h)
  else.
   'bad hash/link'assert (HASHPASSLEN_jd_~:PASS)+.hl-:hash__h;link__h
  end.
 else.
  a=. (;1{a),' jdunique',;'_',each 2}.a
  h=. jdgl_jd_ a
  if. hl-:'' do.
   hl=: forcecopy_jd_ hash__h
  else.
   'bad hash'assert (HASHPASSLEN_jd_~:PASS)+.hl-:hash__h
  end.
 end. 
end.
<.0.5+r
)

jdt=: 3 : 0
timex 'jd''',y,''''
)

NB. test 'h10 a'
NB. test 'h10 a b'
NB. test 'h10 ad'
NB. test 'h10 ad bd'
test=: 3 : 0
(;TYPES,each ' ')test y
:
jdadmin 0
jdadmin '~temp/jdpm/hashtimes'
x=. ;:x
'bad type'assert x e. TYPES
d=. ;:deb y
tab=. ;1{d
cols=. 2}.d
n=. 0".}.tab
hl=: ''
r=. 1 1$<y
for_xi. x do.
 NB. clean and level playing field
 i=. TYPES i.xi
 jd'dropdynamic'
 c=. jdgl_jd_ tab,' jdactive'
 >./dat__c                NB. jdactiv in memory
 cs=. }.;:tc
 for_col. cols do.
  c=. jdgl_jd_ tab,' ',;col
  >./dat__c               NB. col data in memory
 end. 
 jd'close'
 6!:3[PAUSE
 (TV)=: i{V 
 HASHPASSLEN_jd_=: (HASHPASSLEN_jd_=0){(<.n%3),<.2^29
 r=. r,<jdx y
end.
((<UNAME),x),.r
)

tests=: 3 : 0
r=. test y,' a'
r=. r,. test y,' ad'
r=. r,. test y,' a b'
r=. r,. test y,' ad bd'
)


resizetest=: 3 : 0
jdadminx'test'
jd'gen one f 20 1'
jd'createhash f a0'
d=. jd'read from f'
jd'insert f';,d
)

