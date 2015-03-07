NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

jdadmin_z_=:   jdadmin_jd_
jdadminx_z_=:  jdadminx_jd_

coclass'jd'

jdpath=: 3 : 0
d=. getdb''
PATH__d
)

NB. table names,.locales sorted by name
jdtables=: 3 : 0
d=. getdb''
n=. NAMES__d
a=. CHILDREN__d
(/:n){n,.a
)

NB. y is t;c
NB. t is '' for all tables  or 'tab' for just that table
NB. c is '' for all cols    or 'col' for just that col
jdclocs=: 3 : 0
't c'=. ,each y
d=. getdb''
r=. ''
tables=.  NAMES__d
if. #t do.
 'not a table' assert NAMES__d e.~ <t
 tables=. <t
end. 
tablelocs=. ''

NB. table children may not be open - getloc forces open
for_n. tables do.
 tablelocs=. tablelocs,getloc__d n
end. 

for_i. i.#tables do.
 t=. i{tablelocs
 if. #c do.
  'not a column' assert NAMES__t e.~ <c
  cols=. <c
 else. 
  cols=. getdefaultselection__t''
  n=. NAMES__t
  cols=. cols,((<'jd')=2{.each n)#NAMES__t
 end.
 r=. r,(NAMES__t i. cols){CHILDREN__t
end. 
)

NB. non-system col names,.locales sorted by name
jdcols=: 3 : 0
d=. getdb''
t=. getloc__d y
n=. NAMES__t
a=. CHILDREN__t
b=. (<'jd')~:2{.each n
n=. b#n
a=. b#a
(/:n){n,.a
)

jdserverstop=: 3 : 0
if. IFJHS do. OKURL_jhs_=: '' end.
)

NB. simple name treated as ~temp/name
adminp=: 3 : 0
y=. jpathsep y
y=. y,~(-.'/'e.y)#'~temp/jd/'
)

defaultadmin=: 0 : 0
'D' jdadminfp ''
'D' jdadminup 'u/p'
'D' jdadminop '*'
)

NB. jdadmin dbpath - simple name treated as ~temp/jd/name
NB. existing db - set rules
NB. new db in ~temp is created
jdadmin=: 3 : 0
select. y
case. '' do.
 t=. (jdadminfp''),(jdadminup''),(jdadminop''),jdadminlk''
 (/:{."1 t){t
case. 0 do.
 jd'close' 
 jdadminlk 0
 jdadminfp 0
 jdadminup 0
 jdadminop 0
 jdaccess 0
 i.0 0
case. do.
 y=. adminp y
 'not a database'assert 'database'-:jdfread y,'/jdclass'
 d=. }.(y i:'/')}.y
 'w'jdadminlk y
 
 NB. remove old admin for this folder
 dan=. (;(<jpath y)=jpath each {:"1 DBPATHS)#{."1 DBPATHS
 DBPATHS=: (-.({."1 DBPATHS)e.dan)#DBPATHS
 DBUPS=: (-.({."1 DBUPS)e.dan)#DBUPS
 DBOPS=: (-.({."1 DBOPS)e.dan)#DBOPS
 
 bak=. (<DBPATHS),(<DBUPS),<DBOPS
 adminfp=: y
 fp=. y,'/admin.ijs'
 if. -.fexist fp do.
  (defaultadmin rplc 'D';d)fwrite fp NB. create default admin.ijs
 end.
 try.
   load y,'/admin.ijs'
 catch.
   'DBPATHS DBUPS DBOPS'=: bak
   'x'jdadminlk y
   'load admin.ijs failed'assert 0
 end.
 jdaccess d,' u/p intask' NB. default access
 i.0 0
end.
)

jdadminx=: 3 : 0
if. ''-:y do. throw 'y must not be empty' end.
y=. adminp y
if. -.'database'-:jdfread y,'/jdclass' do.
 if. 0~:#fdir y,'/*' do.
  m=. y,' must be empty to be made into a new database'
  throw m
 end. 
end.
d=. }.(y i: '/')}.y
'w'jdadminlk y
p=. jpath y
i=. p i:'/'
f=. Open_jd_ i{.p
'x'jdadminlk y NB.! should be done after Drop - but there are problems
Drop__f d
'w'jdadminlk y
Create__f d
jdadmin y
)

dbrow=: 3 : '({."1 y)i.<DB'

admind=: 4 : 0
if. LF={:y do.
 t=. ' '-.~each<;._2 y
else.
 t=. bdnames y
end. 
db=. x-.' '
assert 0~:#db['DB empty'
db;<t
)

admind=: 4 : 0
db=. x-.' '
assert 0~:#db['DB empty'
db;<deb y rplc LF,' '
)

adminy=: 3 : 0
if. LF={:y do.
 t=. ' '-.~each<;._2 y
else.
 t=. bdnames y
end. 
)

adminx=: 3 : 0
db=. y-.' '
assert 0~:#db['DB empty'
<db
)

adminm=: 4 : 0
if. ''-:y do. x      return. end.
if. 0-:y  do. 0 2$'' return. end.
assert 0['need DB as left arg'
)

NB. DBPATHS
jdadminfp=: 3 : 0
DBPATHS=: DBPATHS adminm y
:
assert ''-:y
y=. adminfp
b=. ({."1 DBPATHS)~:<x
DBPATHS=: (b#DBPATHS),((0~:#y),2)$x;y
i.0 0
)

NB. DBUPS
jdadminup=: 3 : 0
DBUPS=: DBUPS adminm y
:
t=. x admind y
b=. ({."1 DBUPS)~:{.t
DBUPS=: (b#DBUPS),((0~:#>{:t),2)$t
i.0 0
)

NB. DBOPS
jdadminop=: 3 : 0
DBOPS=: DBOPS adminm y
:
t=. x admind y
b=. ({."1 DBOPS)~:{.t
DBOPS=: (b#DBOPS),((0~:#>{:t),2)$t
i.0 0
)

lockopen=: 3 : 0
if. IFWIN do.
 h=. 1!:21 <y
else.
 h=. (LIBC,' open > i *c i')cd y;2
end.
assert 0<h
h
)

lockclose=: 3 : 0
if. IFWIN do.
 1!:22 y
else.
 (LIBC,' close x x')cd y
end.
)

locklock=: 3 : 0
if. IFWIN do.
 r=. 1!:31 y,0 2
else.
 r=. 0=(LIBC,' lockf > i i i i')cd y,2 0 NB. F_TLOCK 2
end. 
)

NB. type lock file- return 1 success and 0 failure
NB. x - x (unlock), r (readonly), or w (read/write)
NB. y - path to jdlock file
lock=: 4 : 0
f=. jpath y,'/jdlock'
if. -.fexist f do.'rw'fwrite f[jdcreatefolder y end.
lf=. (<f) e. {:"1 LOCKED
select. x

case.'w'do.
 if. lf do. 1 return. end.
 h=. lockopen f
 if. locklock h do.
  LOCKED_jd_=: LOCKED,h;f
 else. 
  lockclose h
  assert 0['lock w failed - another task has database locked'
 end.
  
case.'r'do.
 assert 0['lock r not supported'
 
case.'x'do.
 if. lf do.
  i=. ({:"1 LOCKED)i.<f
  lockclose  ;{.i{LOCKED
  LOCKED_jd_=: LOCKED-.i{LOCKED
 end.

case. do.
 assert 0['lock not wrx'
end. 
)

NB. jdadminlk'' is query on lock state
NB. adminlk 0 frees all locks
NB. type adminlk path
NB. type is 'w' 'r' or 'x' unlock
NB. lock is on a file in the database folder
jdadminlk=: 3 : 0
select. y
case. '' do.
 (<'[w]'),._7}.each{:"1 LOCKED
case. 0 do.
 i.0 0['x'jdadminlk each _7}.each LOCKED
case. do.
 assert 0['invalid argument'
end.
:
x lock y
i.0 0
)

NB. serious error (e.g., disk full)
NB. mark db as damaged by writing jddamage file - prevent any more ops on db
NB. signal error
jddamage=: 3 : 0
p=. dbpath DB
y fwrite p,'/jddamage'
((y i.':'){.y) assert 0
)

3 : 0''
if. _1=nc<'DBPATHS' do. DBPATHS=: 0 2$'' end.
if. _1=nc<'DBUPS'   do. DBUPS=:   0 2$'' end.
if. _1=nc<'DBOPS'   do. DBOPS=:   0 2$'' end.
if. _1=nc<'LOCKED'  do. LOCKED=:  0 2$'' end.
LIBC=: unxlib'c'
)



NB. assume headers are non-numeric and end at first number in any column
NB. '' runs all - 0 just sets ALLTESTS
jdtests=: 3 : 0
cocurrent'base' NB. defined in jd, but must run in base
jdtrace_jd_ 1
ALLOC=: ROWSMIN_jdtable_,ROWSMULT_jdtable_,ROWSXTRA_jdtable_
'ROWSMIN_jdtable_ ROWSMULT_jdtable_ ROWSXTRA_jdtable_'=: 4 1 0 NB. lots of resize
jd'option sort 1' NB. required for tests for now
NB. assert -.(<'jjd')e. conl 0['jdtests must be run in task that is not acting as a server'
jdserverstop_jd_''
jd'close'
jdadmin 0
RESIZESTRESS_jdcsv_=: 0

t=. _4}.each 1 dir JDP,'test/*.ijs'
t=. (>:;t i: each '/')}.each t
tsts=. 'core/testall';t
tsts=. (<JDP,'test/'),each tsts,each<'.ijs'
tuts=. {."1[ 1!:0 <jpath JDP,'tutorial/*.ijs'
tuts=. (<JDP,'tutorial/'),each tuts
tuts=. tuts,demos_jd_
t=. ALLTESTS=:  /:~tuts,tsts NB. sorted so they run in same order on windows and linux
if. -.IFJHS do. t=. t-.<JDP,'tutorial/server.ijs' end.

failed=: ''
if. 0-:y do. i.0 0 return. end.

load JDP,'demo/common.ijs'
builddemo'northwind'
builddemo'sandp'
builddemo'sed'

for_n. i.#t do.
  a=. n{t
  NB. echo 'loadd''','''',~;a
  'test'trace_jd_ a
  try.
    load a
  catch.
   'test failed'trace_jd_ a
   echo LF,('failed: ',;n{t),LF,13!:12''
   failed=: failed,a
  end.
end.

jdserverstop_jd_''

NB. csv tests
load JDP,'csv/csvtest.ijs'
RESIZESTRESS_jdcsv_=: 0
'test csv'trace_jd_ 0 
tests''
RESIZESTRESS_jdcsv_=: 1
'test csv'trace_jd_ 1 
tests''
RESIZESTRESS_jdcsv_=: 0

jd'close'
jdadmin 0

if. #failed do.
 NB. echo LF,'known problems:'
 echo LF,'following tests failed:'
 echo each (<'loadd'''),each failed,each<''''
end.
if. #conl 1 do.
 echo LF,'check for orphan locals in conl 1'  
end.
echo LF,(":#t),' tests run',LF,(":#failed),' failed'
jd'option sort 0' NB. restore
'ROWSMIN_jdtable_ ROWSMULT_jdtable_ ROWSXTRA_jdtable_'=: ALLOC NB. restore
jdtrace_jd_ 0
i.0 0
)

jd_testerrors=: 3 : 0
select. y
case. 'best'  do. ('table * does not have col *'erf'abc';'def')assert 0
case. 'bare'  do. assert 0
case. 'right' do. assert 0['simple assert right'
case. 'left'  do. 'simple assert left'assert 0
case. 'leftx' do. ('formatted assert X on left'rplc'X';'88')assert 0
case. 'throw' do. throw 'thrown X'rplc'X';'999'
case. 'plain' do. 1+'a'
end.
)

jdtesterrors=: 3 : 0
jdadminx'test'
t=. 'best';'bare';'right';'left';'leftx';'throw';'plain'
for_n. t do.
 n=. >n
 try. 
  jd'testerrors ',n
 catch.
  t=. LASTRAW_jd_
  t=. dltb each }.each<;._2 t
  v=. >{.t
  if. 'assertion failure: assert'-:v do.
   r=. >1{t
   if. ''''={:r do.
    r=. }:r
    r=. r rplc '''''';{.a.
    i=. r i: ''''
    r=. }.i}.r
    r=. r rplc ({.a.);''''
   end.
  elseif. ': assert'-:_8{.v do.
   r=. _8}.v
  elseif. ': throw'-:_7 {.v do.
   r=. _7}.v
  elseif. 1 do.
   r=. ;  ( {.t) ,(<': '), }.t
  end.
  echo r
 end.
end. 
)

jdshare=: 3 : 0
p=. dltb y
assert 6=#p
p=. 3 2$p
t=. IFWIN{9 3
(t{.,p,.'x') 1!:7 dirpath dbpath DB
(t{.,p,.'-') 1!:7 {."1 dirtree dbpath DB
JDOK
)

NB. add jd'...' index to user.html
setuser=: 3 : 0
t=. 3}.each/:~'jd_'nl_jd_ 3
t=. t-.'testerrors';'ref';,'x'
d=. (<'<a href="#'),each t,each <'">'
d=. d,each t,each <'</a>'
d=. ;d,each LF
r=. jdfread JDP,'jd/doc/user.html'
a=. '<!-- opindex a -->'
z=. '<!-- opindex z -->'
i=. (#a)+1 i.~ a  E. r
j=. 1 i.~ z E. r
r=. (i{.r),d,j}.r
r fwrite JDP,'doc/user.html'
f=. ''
for_n. t do.
 f=. f,(0=+/('<a name="',(;n),'">') E. r)#n
end.
if. 0~:#f do. echo 'ops without targets:',LF,;' ',each f,each LF end.
i.0 0
)

NB. add jd names that do not have links from z
setadmin=: 3 : 0
t=. ('jd'nl_jd_ 3)-.setztojd''
t=. t-.'jd_'nl_jd_ 3
t=. t-.'jdadmin'nl_jd_ 3
t=. t-.'jdcreatejmf';'jdmap';'jdunmap';'jdx'
d=. (<'<a href="#'),each t,each <'">'
d=. d,each t,each <'</a>'
d=. ;d,each LF
r=. jdfread JDP,'doc/admin.html'
a=. '<!-- jdutilindex a -->'
z=. '<!-- jdutilindex z -->'
i=. (#a)+1 i.~ a  E. r
j=. 1 i.~ z E. r
r=. (i{.r),d,j}.r
r fwrite JDP,'doc/admin.html'
f=. ''
for_n. t do.
 f=. f,(0=+/('<a name="',(;n),'">') E. r)#n
end.
if. 0~:#f do. echo 'jd... without targets:',LF,;' ',each f,each LF end.
i.0 0
)

NB. jd... names in z locale that link to jd locale
setztojd=: 3 : 0
t=. 'jd'nl_z_ 3
t=. (0=;L. each 5!:1 t,each<'_z_')#t
a=. 5!:1 t,each<'_z_'
((<'_jd_')=_4{.each a)#t
)

NB. y is tab/col path
NB. jdfread/jdfwrite col folder files to new location (probably on another drive)
NB. and make symbolic link
jdlinkmove=: 3 : 0
'tc newp'=. bd2 y
p=. jdpath_jd_''
i=. '/' i:~ }:p
p=. p,tc
newp=. jpath newp,i}.p
jdcreatefolder newp
('folder * is not empty'erf newp)assert 0=#fdir newp,'/*'
a=. {."1 [1!:0 <p,'/*'
for_f. a do. (jdfread p,'/',;f) fwrite newp,'/',;f end.
jd'close' NB. necessary so remap is done with new stuff
if. IFWIN do.
 t=. '"',p,'" "',newp,'"'
 t=. 'mklink /D /J ',t rplc '/';'\'
 rmdir p
 shell t NB. wndows does junction between folders
else.
 n=. '"',newp,'" "',(_5}.p),'"'
 t=. 'ln -s ',n
 rmdir p
 shell t
end.
)

NB. report db link targets
jdlinktargets=: 3 : 0
if. IFWIN do.
 r=. <;._2 toJ shell 'dir /S "P"'rplc 'P';jdpath''
 b=. ;+./each(<' <JUNCTION> ')E.each r
 r=. b#r
 }:each(>:;r i.each'[')}.each r
else.
 r=. <;._2 toJ shell 'ls -l -R "P"'rplc 'P';jdpath''
 r=. ((<'lrw')=3{.each r)#r
 (r i.each'/')}.each r
end.
)

NB. validate and set links.txt in database folder
jdlinkset=: 3 : 0
f=. 'links.txt',~jdpath''
if. y-:0 do.
 ferase f
 i.0 0
 return.
end.
if. y-:'' do.
 if. _1=r=.jdfread f do. r=. '' end.
 r
 return.
end.
links=. toJ y
links=. links,LF#~LF~:{:links
links=. <;._2 links
links=. >bd2 each links
n=. {."1 links
'invalid tab/col - missing /' assert 1=;+/each'/'=each n
'invalid tab or col name' assert _2~:nc bdnames(;n,each' ')rplc '/';' '
p=. {:"1 links
jdcreatefolder each p
r=. ,LF,.~showbox links
r fwrite 'links.txt',~jdpath''
r
)

NB. get locale for table or table column 
jdgl=: 3 : 0
d=. getdb''
a=. bdnames y
if. 1=#a do.
 getloc__d ;a
else.
 t=. getloc__d ;{.a
 getloc__t ;{:a
end.
)

NB. get state for table or table column
jdgs=: 3 : 0
c=. jdgl y
3!:2 fread PATH__c,'jdstate'
)
 
jdfrom=:  4 : '>{:(({."1 y)i.<,x){y'

jdfroms=: 4 : '>(({.y)i.<,x){"1{:y'

TRACEFILE=: '~temp/jd/trace.txt'

jdtrace=: 3 : 0
TRACE=: y
if. y do. (LF,~'trace:     ',":6!:0'')fwrite TRACEFILE end.
i.0 0
)

trace=: 4 : 0
if. TRACE do.
 t=. (25{.x),': '
 if. ''-:y do.
  t=. t,LF
 else.
  t=. t,,(showbox boxopen y),.LF
 end.
 t fappend TRACEFILE
end. 
)

jdrt=: 3 : 0
pa=. JDP,'tutorial/'
ta=. (<pa),each {."1[1!:0 jpath pa,'*.ijs'
aa=. _4}.each(>:;ta i: each '/')}.each ta
aa=. (_4*;(_4{.each aa)=<'_tut')}.each aa 
TUTSDEMO=: _4}.each(>:;demos i:each'/')}.each demos
TUTSBASIC=: 'intro';'reads';'from';'admin';'csv';'join';'epochdt'
TUTSADVANCED=: aa-.TUTSBASIC
TUTS=: (aa,TUTSDEMO),.ta,,demos_jd_
y=., dltb y
if. y-:'' do.
 t=. <'  '
 r=.   (<'basic:'),t,each TUTSBASIC
 r=. r,(<'demo:'),t,each TUTSDEMO
 r=. r,(<'advanced:'),t,each TUTSADVANCED
 ;r,each LF
 return.
end.
if. y-:'help' do.
 echo'   spx 0   NB. status'
 echo'   spx 4   NB. run line 4'
 echo'   spx 4 8 NB. run line 4 up to 8'
 return.
end. 

i=. ({."1 TUTS)i.<y
'invalid tutorial name'assert i<#TUTS
f=. ;{:i{TUTS

if. IFJHS do.
 echo'ctrl+. to advance - click link to open - jdrt_jd_''help'''
 open f
elseif.IFQT do.
 echo 'ctrl+j to advance - jdrt''help'''
 open f
elseif. do.
 echo '   spx'''' NB. to advance'
end. 
 
spxinit f
)




