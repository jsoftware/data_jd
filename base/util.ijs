NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
jdrt_z_=:      jdrt_jd_

coclass 'jd'

NB. windows createprocess
NB. fork_jtask_ leaves stdin/stdout hooked up
NB. following should be refactored into jtasks
NB. /S strips leading " and last " and leaves others alone
NB. win32 requires 104->68 ; 16->24 ; _2 ic 8{.pi -> _3 ic 16{.pi
winserver=: 3 : 0
'only valid on win64'assert IF64
CloseHandle=. 'kernel32 CloseHandle i x'&cd"0
CreateProcess=. 'kernel32 CreateProcessW i x *w x x i  i x x *c *c'&cd
f=. 16b08000000
c=. uucp 'cmd /S /C "',y,'"'
si=. (104{a.),104${.a.
pi=. 24${.a.
'r i1 c i2 i3 i4 f i5 i6 si pi'=. CreateProcess 0;c;0;0;0;f;0;0;si;pi
'createprocess failed'assert 0~:r
decho (_3 ic 16{.pi),_4 ic 16}.pi
decho CloseHandle _3 ic 16{.pi
)

NB. fork task for all platforms
NB. windows fork_jtask_ new task is killed if creator task is killed
NB. winservre_jcs_ avoids this
jdfork=: 3 : 0
if. IFWIN do.
 winserver_jd_ y NB. jd version of winserver
else.
 fork_jtask_ y
end. 
i.0 0
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
t=. ((
(#y)%2),2)$y
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
if. x do. 'ptable not allowed'assert 0=S_ptable__t end. NB.! test not right
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

NB. 9.4 stdlib - we need it in older installs - in jd locale
dquotex=: 3 : 0
s=. y#~ >: m=. (=&'"') y
p=. (i.#y)#~>: m
('"'&,@(,&'"')) '\' (p i.(I.m))}s
)

NB. assert that fsize=HS+msize and fsize is within pad of page boundary
chksize=: 3 : 0
d=. }.showmap_jmf_''
fs=. ;MAPFSIZE_jmf_{"1 d
ms=. ;MAPMSIZE_jmf_{"1 d
r=. -.HS_jmf_=fs-ms
if. +./r do.
 echo r# d
 'bad fsize vs msize'assert 0
end.
r=. -.0=PAGESIZE_jd_|fs+JMFPAD_jd_
if. +./r do.
 echo r# d
 'bad fsize page boundary'assert 0
end.
)

NB. boolean mask - names starting with jd
bjdn=: 3 : 0
(<'jd')=2{.each y
)

ophtmls=: _4}.each(>:#jpath JDP,'doc')}.each 1 dir JDP,'doc/Ops_*'

jdrt=: 3 : 0
load JDP,'tools/tut.ijs'
if. -.IFJHS do.
 require'labs/labs'
 runtut=: lab_z_
else.
 require'~addons/ide/jhs/sp.ijs'
 runtut=: spx_jsp_
end.
builddemos''
if. ''-:y do.
 t=.(' '~:;{.each tuts)#tuts
 ;LF,~each(<'   jdrt '''),each t,each''''
 return.
end.
i=. (dltb each tuts)i.<'>',~dltb y NB. first look for >
if. i=#tuts do.
 i=. (dltb each tuts)i.<dltb y
end.
'invalid tut'assert i<#tuts
p=. a=. ;i{tuts
b=. (a=' ')i.0 NB. count leading blanks
t=. }.i}.tuts
c=. ;(t=each' ')i.each 0 NB. count leading blanks
i=. (b<c)i.0
t=. i{.t
a=. ;{.t
b=. (a=' ')i.0 NB. count leading blanks
c=. ;(t=each' ')i.each 0 NB. count leading blanks
t=. (b>:c)#t
t=. dltb each t

if. 0<#t do.
 ;LF,~each(<'   jdrt '''),each t,each''''
 return.
end.
f=. JDP,'tutorial/',(dltb p),'_tut.ijs'
'invalid tutorial name'assert fexist f
runtut f
)

NB. '' assumed ok if folders exist - not empty rebuilds from scratch
builddemos=: 3 : 0
b=. jdfread each'~temp/jd/northwind/jdclass';'~temp/jd/sandp/jdclass';'~temp/jd/sed/jdclass'
if. (0=#y)*.*./b=<'database' do. i.0 0 return. end.
echo'building demos - takes time'
if. IFQT do. wd'msgs' end.
load__ JDP,'demo/common.ijs'
builddemo__'northwind'
builddemo__'sandp'
builddemo__'sed'
jdadmin 0
)

NB. widows bug?
NB.  fexist seems to 'sync' file ops and prevents ftypex from giving wrong answer 
ftypex=: 3 : 0
fexist y
ftype  y
)

inrange =: ([: *./ (>: {.) , (<: {:))~ NB. general/misc/validate

reduce =: 1 : ('u/ y';':';'for_z. |.x do. y=.z u y end.')

dcreate=: (1!:5 :: 0:) @ (fboxname@:>)
derase=: (1!:55 :: 0:) @ (fboxname@:>)

pack=: [: (,. ".&.>) ;: ::]
pdef=: 3 : '0 0$({."1 y)=: {:"1 y'
termSEP=: , (0 < #) # '/' -. {:
tocolumn=: ,. @: > each

throw=: 13!:8&101

rethrow=: throw @ (13!:12@(''"_) , ])
throwmsg=: }. @ ({.~i.&LF) @ (13!:12)

NB. =========================================================
MAX_INT =: 2^64x
to_unsigned =: MAX_INT | x:

NB. =========================================================
coinserttofront =: 3 : 0
p=. ; <@(, 18!:2)"0  ;: :: ] y
p=. ~. p, (18!:2 coname'')
(p /: p = <,'z') 18!:2 coname''
)

NB. =========================================================
NB. dirsubdirs
NB. return sub directories in top level directory
NB. ignore any hidden files
dirsubdirs=: 3 : 0
r=. 1!:0 (termSEP y),'*'
if. 0=#r do. '' return. end.
{."1 r #~ '-d' -:("1) 1 4{"1 > 4{"1 r
)

NB. convert varbyte boxes from internal format
vbfix=: 3 : 0
c=. ;#each y
(n=. (0,}:+/\c),.c);;y
)

jddeletefolder=: 3 : 0
a=. (-'/'={:y)}.y NB. drop trailing /
y=. jpath a
en=. 'delete folder ',y,' not allowed'
(en,' - locked')assert -.(<y)e.{:"1 jdadminlk_jd_''       NB. err - locked
(en,' - file')assert 1~:ftype y                           NB. err - is a file

if. -.fexist y,'/jddeleteok' do.
 (en,' - jddropstop')assert -.fexist y,'/jddropstop'
 if. -.0=#fdir y,'/*' do. 
  p=. jpath'~temp/'
  (en,' - not jdclass or ~temp')assert (fexist y,'/jdclass')+.p-:(#p){.y
 end.
end.

r=. rmsub y
if. 0~:;{.r do.
 echo 'Jd info: jddeletefolder failed: ',y
 echo IFWIN#' see doc technical|wss'
 echo ' trying again'
 for. i.10 do.
  6!:3[1
  r=. rmsub y
  if. 0=;{.r do.
   echo' succeeded'
   y return. end.
 end.
 echo' failed!'
 'jddeletefolder' logtxt y;r
 ('delete folder ',y,' failed')assert 0
end.
a
)

jddeletefolderok=: 3 : 0
y[''fwrite y,'/jddeleteok'
)

NB. write (x 1) or erase (x 0) all jddropstop files in path
NB. x 0 erase - x 1 write
NB. y is '' or 'table' or 'table col'
jddropstop=: 3 : 0
1 jddropstop y
:
p=. dirpath(jdpath''),(deb y)rplc' ';'/'
p=. p,each<'/jddropstop'
if. x=0 do.
 ferase each p
else.
 a: fwrite each p
end.
i.0 0
)

jdcloseflush=: 3 : 0
f=. 'jdcloseflush',~jdpath''
if. y=0 do.
 ferase f
else.
 ''fwrite f
end. 
i.0 0
)

jdcreatefolder=: 3 : 0
t=. jpath dltb y
for_n. ('/'=t)#i.#t=. t,'/'  do.
  1!:5 :: [ <n{.t
end.
('jdcreatefolder failed: ',y) assert 2=ftypex y
y
)

NB. Windows Search Service (content indexing, ...) and and other windows background tasks can cause rmdir to fail
NB. the problem is mitigated by doing rmdir several times as required with a sleep
NB. if the open blocking the delete stays, then rmsub will fail and the user will get an error

NB. rmsub (old version) was very slow on windows with non ssd
NB. shell_jtask_ has lots of file ops (createpipe) and performed badly

NB. version with just J foreign
rmsub=: 3 : 0
p=. jpath y
d=. 1!:0 p
if. 1~:#d do. 0;'' return. end. NB. folder does not exist
if. 'd'~:4{4 pick{.d do. ('not a folder: ',y) assert 0 end.
t=. ,&'/'^:('/'~:{:) jpathsep y
if. (<filecase_j_ t) e. filecase_j_@:((#t)&{.)&.> 1{"1 }.showmap_jmf_ '' do. ('contains mapped files: ',t) assert 0 end.
dr=. 1!:0 p,'/*'
if. 0~:#dr do.
 fn=. {."1 dr
 fb=. 'd'~:4{"1>4{"1 dr
 fs=. fb#fn
 ds=. fn#~-.fb
 if. #fs do. 
  pf=. (<p),each '/',each fs
  ferase pf
 end.
 for_a. ds do.
  rmsub p,'/',;a
 end.
end. 
1!:55 :: [ <p
if. 0=#1!:0 p do. 0;'' return. end.
6!:3[0.1 NB. sometimes required in windows so next test works
if. 0=#1!:0 p do. 0;'' return. end. 
1;'delete did not complete'
)

NB. need general mechanism to log progress on long running operations
NB. this is a crude place holder for what is required
logprogress=: 3 : 0
try. y fwrite '~temp/jdprogress' catch. end.
)

NB. format utils

NB. convert jd'...' table to HTML
tohtml=: 3 : 0
'</table>',~'<table>',;(<'<tr>'),.(tohtmlsub each y),.<'</tr>',LF
)

tohtmlsub=: 3 : 0
t=. y
if. 1=L.t do.
 t=. _1}.;t,each','
else.
 t=. ":t
 t=. }:,t,"1 LF
end.
t=. t rplc '&';'&amp;';'<';'&lt;';LF;'<br>'
t=. '<td>',t,'</td>'
)

totext=: 3 : ',LF,.~sptable y'

NB. convert jd'...' table to JSON
tojson =: verb define
if. 0=#y do. '' return. end.
'hdr dat'=. 2{.<"1 boxopen y
if. 0=#dat do. NB. no header was provided
 dat =. hdr
 hdr =. <@('column'&,)@":"0 i.#dat      NB. auto-generate column names
end.
NB.
 lbl      =. dquote each hdr
 colcount =. #dat
 rowcount =. #&>{.dat

 NB. format each column as JSON
 json =. (colcount) $ a:
 for_colndx. i. colcount do.
  col  =. (((>colndx{lbl),':'),])@dquote@escape_json_chars@dltb@":"1 each colndx{dat
  json =. col (colndx) } json
 end.
 NB. merge the individual JSON columns into a bi-dimensional char array
 json =. >((>@[) ,. ((rowcount,1)$',') ,. (>@])) / json
 NB. enclose each row between {} to represent JSON objects, add ',' and CRLF to the end of each row and raze the array
 json =. ;('{',])@(('},',CRLF),~])"1 json
 NB. amend in-place to discard the last ',' and CRLF
 json =. ' ' (-1 2 3) } json
 NB. enclose the resulting objects in [] to represent an array,
 json =. ('[',])@(']',~]) json
 NB. name the array
 json =. ('{"rows": ',])@('}',~]), json
)
escape_json_chars =: rplc&((_2[\CR;'\n';LF;'\r';TAB;'\t'), <;._2 @(,&' ');. _2 [0 : 0)
" \"
\ \\
/ \/
)

NB. Convert using escapes as in C printf (used in where clause parsing)
cescape =: ({. , ({.,$:@}.)@:cescape1@:}.)^:(<#)~ i.&'\'
NB. Argument starts with \
cescape1 =: 3 : 0 @: }. :: ('\'&,)
oct =. 8 {. hex =. 16 {. HEX =. '0123456789abcdefABCDEF'
char =. '"\abefnrtv'  [  res =. '"\',7 8 27 12 10 13 9 11{a.
select. {.y
  case. <"0 oct do. ((}. ,~ a.{~256|8#.oct i. {.)~ 3 <. i.&0@:e.&oct) y
  case. 'x' do.
    if. HEX -.@e.~ 1{y do. throw 'Missing hex digit for \x' end.
    ((}. ,~ a.{~16#.hex i. tolower@{.)~ 2 <. i.&0@:e.&HEX) }.y
  case. 'u';'U' do.
    if. HEX -.@e.~ 1{y do. throw 'Missing unicode digit for \',{.y end.
    l =. ((4 8{~'uU'i.{.) <. i.&0@:e.&HEX@:}.) y
    'c y' =. l (}. ;~ [:#:16#.hex i. tolower@{.) }.y
    n =. 5>.@%~<:@# c
    y ,~ a. {~ #. 1 (0,&.>i.n)} 1 0 ,"_ 1] _6 ]\ c {.~ _6*n
  case. <"0 char do. (}. ,~ res{~char i.{.) y
  case. do. '\',y
end.
)

NB. replace text in "s with blanks - phrase m59
blankq=: 3 : 0
' ' ((i.#y)#~(2:*./\0:,2:|+/\@(=&'"'))y)}y
)

TYPES=: <;._2 ]0 :0
boolean
int
float
byte
varbyte
date
datetime
edate
edatetime
edatetimem
edatetimen
int1
int2
int4
)

TYPES_SIZES=: 1 8 8 1 8 8 8 8 8 8 8 1 2 4

TYPES_E=: ;:'edate edatetime edatetimem edatetimen'

TYPES_D=: ;:'date datetime'

jdfread=: 3 : 0
t=. fread y
if. (_1-:t)*.10=13!:11'' do.
 ('file read limit error (Technotes|file handles): ',;y)assert 0
end.
t
)
 
jdfwrite=: 4 : 0
t=. x fwrite y
if. (_1-:t)*.10=13!:11'' do.
 ('file write limit error (Technotes|file handles): ',;y)assert 0
end.
t
)

NB. jdsuffle 'table'
NB. (100<.#rows) random rows are deleted/inserted one row at a time
NB. (100<.#rows) random rows are deleted/insertt in bulk
NB. result is arg which allows: jdshuffle^:3 'foo'
jdshuffle=: 3 : 0
'tab'=. y
d=. /:~|:><"1 each ,.each {:jd'reads from ',tab

NB. shuffle random rows 1 at a time
v=. ((100<.>.0.25*#v){.?~#v){v=. ,>{:jd'reads jdindex from ',tab

for_i. v do.
 t=. jd'read from ',tab,' where jdindex=',":i
 jd ('delete ',tab);'jdindex=',":i
 jd ('insert ',tab);,t
end.

NB. shuffle random rows in bulk
v=. ((100<.>.0.25*#v){.?~#v){v=. ,>{:jd'reads jdindex from ',tab
test=. 'jdindex in (',(}.;',',each":each v),')'
t=. jd'read from ',tab,' where ',test
jd ('delete ',tab);test
jd ('insert ',tab);,t

z=. /:~|:><"1 each ,.each {:jd'reads from ',tab
'shuffle failed' assert d-:z
y
)

cnts=: ;:'writestate readstate map resize'

cntsclear=: 3 : 0
cntslast=: ;".each (<'cnts_'),each cnts,each <'_jd_'
".each (<'cnts_'),each cnts,each <'_jd_=:0'
cntslast
)

NB. http://code.jsoftware.com/wiki/Essays/Inverted_Table
ifa =: <@(>"1)@|:               NB. inverted from atoms
afi =: |:@:(<"_1@>)             NB. atoms from inverted

tassert=: 3 : 0
 assert. (1>:#$y) *. 32=3!:0 y  NB. boxed scalar or vector
 assert. 1=#~.#&>y              NB. same # items in each box (with at least one box)
 1
)

ttally    =: #@>@{.
tfrom     =: <@[ {&.> ]
tindexof  =: i.&>~@[ i.&|: i.&>
tmemberof =: i.&>~ e.&|: i.&>~@]
tless     =: <@:-.@tmemberof #&.> [
tnubsieve =: ~:@|:@:(i.&>)~
tnub      =: <@tnubsieve #&.> ]
tkey      =: 1 : '<@tindexof~@[ u/.&.> ]'
tgrade    =: > @ ((] /: {~)&.>/) @ (}: , /:&.>@{:)
tgradedown=: > @ ((] \: {~)&.>/) @ (}: , \:&.>@{:)
tsort     =: <@tgrade {&.> ]
tselfie   =: |:@:(i.~&>)

NB. alternatives
tmemberof1=: tindexof~ < ttally@]
tnubsieve1=: tindexof~ = i.@ttally
ranking   =: i.!.0~ { /:@/:
tgrade1   =: /: @ |: @: (ranking&>)

jdtypefromdata=: 3 : 0
typ=. ;(1 4 8 2 i. 3!:0 y){'boolean';'int';'float';'byte';'varbyte'
if. typ-:'varbyte' do.
 'varbyte bad shape'assert 1=$$y
 'varbyte bad shapes' assert 1>:;$@$each y
 'varbyte bad types' assert 2=;3!:0 each y
end.
typ
)

NB. get zip file from joftware jdcsv and unzip in CSVFOLDER
NB. used by bus_lic and qunadl_ibm tutorials
getcsv=: 3 : 0 NB. get csv file if it doesn't already exist
if. -.fexist CSVFOLDER__,y do.
 require'pacman' NB. httpget
 'rc fn'=. httpget_jpacman_'www.jsoftware.com/download/jdcsv/',(y{.~y i.'.'),'.zip'
 'httpget failed'assert 0=rc
 unzip=. ;(UNAME-:'Win'){'unzip';jpath'~tools/zip/unzip.exe'
 t=. '"',unzip,'" "',fn,'" -d "',(jpath CSVFOLDER__),'"'
 if. UNAME-:'Win' do. t=. '"',t,'"' end.
 r=. shell t
 ferase fn
 r,LF,'CSVFOLDER now contains the csv file'
else.
 'CSVFOLDER already contains the csv file'
end.
)

NB. get file from jsoftware jdcsv and put it in ~temp/jdfiles
getjdfile=: 3 : 0
require'pacman' NB. httpget
snk=. '~temp/jdfiles/'
jdcreatefolder_jd_  snk
if. -.fexist snk,y do.
 'rc fn'=. httpget_jpacman_'www.jsoftware.com/download/jdcsv/',y
 'httpget failed'assert 0=rc
 (snk,y) frename fn
 m=. 'file downloaded: '
else.
 m=. 'already exists: '
end.
m,snk,y
)
