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

optget=: 3 : 0
if. 0~:L.y do. (<}.y),<{.y  return. end.
y=. dlb y
b=. '"'={.y
if. b do.
 y=. }.a
 i=. y i.'"'
else.
 i=. y i.' '
end. 
v=. i{.y
a=. b}.i}.y
i=. y i. ' '
v=. i{.y
y=. }.i}.y
y;v
)

NB. y is jd_... ... 
NB. x is list of options and their type
NB. result is y with options stripped
NB. option_name_jd_ set as option value
NB. options not provided are set to 0
NB. option type 0 set to 1
NB. option type 1 must be positive integer
NB. option type a (alloc) must be 3 positive integer/float
NB. option type s is a string - if string arg it can be in "s
NB. a=. '/e 0 /nx 1 /a a /s s'getopt '/e /nx 23 /a 1 2 3.5 /s "abc def"'
getopts=: 4 : 0
t=. ca x
t=. (2,~-:#t)$t
n=. {."1 t
c=. {:"1 t
p=. ;(<'_jd_ '),~each (<'option_'),each}.each n
(p)=: 0 NB. default value for options not provided
a=. y
while. '/'={.v[v=. ;v['b v'=. optget a do.
 a=. b
 t=. }.v
 p=. 'option_',(}.v),'_jd_'
 i=. n i. <v
 EOPTION assert i < #n
 v=. ''$;i{c
 select. v
 case. '0' do.
  v=. 1
 case. '1' do.
  'a v'=. optget a
  v=. 0+_".;v
  EOPTIONV assert 4=3!:0 v
  EOPTIONV assert 0<:v
 case. 'a' do. NB. createtable /a - 3 values and float allowed
  'a v0'=. optget a
  'a v1'=. optget a
  'a v2'=. optget a
  v=. 0+_".(;v0),' ',(;v1),' ',;v2
  EOPTIONV assert 3=#v
  EOPTIONV assert 0<:v
 case. 's' do. NB. string - asdf or "abc def"
  if. 0~:L.a do.
   v=. ;{.a
   a=. }.a
  else.
   a=. dltb a
   if. b=. '"'={.a do.
    a=. }.a
    i=. a i.'"'
   else.
    i=. a i.' '
   end. 
   v=. i{.a
   a=. b}.i}.a
  end. 
 case. do.
  'bad option type' assert 0
 end.
 (p)=: v
end.
a
)

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
;i{{:"1 DBPATHS
)

NB. box blank delimited name and the rest
bd2=: 3 : 0
if. 0=L.y do.
 t=. dltb y
 i=. t i. ' '
 dltb each (i{.t);}.i}.t
else.
 dltb each y 
end.
)

NB. box 2 blank delimited names and the rest
bd3=: 3 : 0
if. 0=L.y do.
 t=. dltb y
 i=. t i. ' '
 dltb each (<i{.t),bd2 i}.t
else.
 dltb each y 
end.
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

jdfixcolnames=: 3 : 0
v=. vsub ,y
ns=. {."1 v
vs=. {:"1 v
ns=. ns rplc each <'.';'-';' ';'_'
,ns,.vs
)

vdname=: 3 : 0 NB. validate dan name
('invalid name: ',y)assert (0~:#y) *. ('~'~:{.y) *.(2=3!:0 y) *. (2>$$y) *. (*./-.RESERVEDCHARS e. y) *. -.RESERVEDWORDS e.~<y
if. UNAME-:'Darwin' do. ('invalid name (OSX filename - unicode composed vs decomposed): ',y)assert 127>a.i.y end.
)

vtname=: 3 : 0 NB. validate table name
('invalid name: ',y)assert -.'jd'-:2{.y
vdname y
)

vcname=: vtname NB. validate column name

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
