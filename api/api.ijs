NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

coclass'jd'

0 : 0
API internal globals

 DB  - database name - simple name - jdadmin connects to files and access rules
 dbl - database locale

 jd_...  verbs implement a Jd op
 jdi_... verbs cover ops so they can be used interally by other ops (manage state)
)

NB. 'insert table * col * bad'erf table;col
erf=: 4 : 0
y=. ')',~each'(',each boxopen y
i=. ('*'=x)#i.#x
t=. 'ABCDEFGHI'{.~#i
x=. t i}x
x rplc  ,(,.<"0 t),.,.boxopen y
)

jd_z_=: jd_jd_

initserver_z_=: 3 : 0
if. ''-:y do.
 d=. {."1[1!:0 jpath JDP,'config/server_*.ijs'
 >_4}.each 7}.each d
 return.
end. 
load'~addons/ide/jhs/core.ijs'
load JDP,'config/server_',y,'.ijs'
smoutput BIND_jhs_,':',":PORT_jhs_
smoutput jdadmin''
smoutput 'OKURL',;' ',each OKURL_jhs_
init_jhs_''
)

vsub=: 3 : 0
'bad arg: pairs of names;values' assert (2<:#y)*.0=2|#y
t=. (((#y)%2),2)$y
(,each{."1 t),.{:"1 t NB. ugly make scalar col names lists
)

dbpath=: 3 : 0
i=. ({."1 DBPATHS)i.<,y
'not a db access name'assert i<#DBPATHS
;i{ {:"1 DBPATHS
)

jdcdef=: 3 : 0
v=. vsub ,y
ns=. {."1 v
vs=. {:"1 v
vcname each ns
duplicate_assert ns
typ=. ;3!:0 each vs
ETYPE assert 8>:ts
typ=. typ{'';'boolean';'byte';'';'int';'';'';'';'float'
ts=. ":each }.each $each vs
ETALLY assert c={.c=. ;#each vs
deb _3}.' ',;ns,each' ',each typ,each' ',each ts,each<' , '
)

NB. OSX pre catalina - if. UNAME-:'Darwin' do. ('invalid name (OSX filename - unicode composed vs decomposed): ',y)assert 127>a.i.y end.
vname=: 3 : 0 NB. validate name
('invalid name: ',y)assert (0~:#y) *. (2=3!:0 y) *. 2>$$y
('invalid name - unprintable chars: ',y) assert -.y e.~32{.a.
)

vdname=: 3 : 0 NB. validate dan name
vname y
('invalid name - RESERVEDCHARS_jd_: ',y)assert -.RESERVEDCHARS e. y
)

vtname=:  3 : 0 NB. validate table name
vdname y
('invalid name - jd prefix: ',y)assert -.'jd'-:2{.y
('invalid name - RESERVEDWORDS_jd_: ',y)assert -.RESERVEDWORDS e. <y
)

vcname=: 3 : 0 NB. validate col name
vname y
('invalid name - jd prefix: ',y)assert -.'jd'-:2{.y
)

opened=: 3 : 0
ECOUNT assert 0=#y
r=. ''
for_n. NAMES_jd_ do.
 f=. Open_jd_ >n
 p=. PATH__f
 for_d. CHILDREN__f do.
  r=. r,<p,NAME__d
 end.
end.
r
)

getfolder=: 3 : 0
db=. dbpath DB
p=. jpath db
i=. p i:'/'
(Open_jd_ i{.p);(>:i)}.p
)

NB. y is boxed list of table,col(s)
NB. table and cols must exist and be valid user names
NB. x 1 if ptable is allowed
NB. cols not allowed types float/varbyte/int1/int2/int4
validtc=: 3 : 0
1 validtc y
:
notjd_assert y
if. -.({.y)e.NAMES do. ('jde: not found: table (TAB)' rplc 'TAB';;{.y) assert 0 end.
t=. getloc {.y
if. x do. 'ptable not allowed'assert 0=S_ptable__t end. NB! test not right
a=. (}.y)-.NAMES__t
if. #a do. ('jde: not found: table (TAB) column (COL)' rplc 'TAB';(;{.y);'COL';;{.a)assert 0 end.
for_c. }.y do.
 w=. getloc__t c
 'varbyte not allowed' assert -.'varbyte'-:typ__w
 'float not allowed'   assert -.'float'-:typ__w
 'int1 not allowed'    assert -.'int1'-:typ__w
 'int2 not allowed'    assert -.'int2'-:typ__w
 'int4 not allowed'    assert -.'int4'-:typ__w
end. 
)

assertnoref=: 3 : 0
t=. jdgl y
a=. {."1 SUBSCR__t
'table has ref' assert 0=+/;(<'jdref')=5{.each a
'table has ref' assert 0=+/;+/each(<'.jdref')E.each a
)

assertnodynamic=: 3 : 0
t=. jdgl ;{.y
'col has dynamic' assert  -.({:y)e.;{:"1 SUBSCR__t
)

assertnotptable=: 3 : 0
t=. jdgl y
EPTABLE assert 0=S_ptable__t
)
