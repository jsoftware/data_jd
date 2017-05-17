NB. Copyright 2015, Jsoftware Inc.  All rights reserved.
jdadmin_z_=:   jdadmin_jd_
jdadminx_z_=:  jdadminx_jd_

coclass'jd'

jdpath=: 3 : 0
1 jdpath y
:
d=. x getdb''
PATH__d
)

NB. x 1 does db validation (damage and class)
NB. x 0 skips db validation
getdb=: 3 : 0
1 getdb y
:
db=. dbpath DB
if. x do.
 'db damaged'assert (0=ftypex) db,'/jddamage'
 'not database class'assert 'database'-:jdfread db,'/jdclass'
end. 
i=. db i:'/'
floc_z_=: f=. Open_jd_ jpath i{.db
dloc_z_=: Open__f (>:i)}.db
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
NB. tables  in sorted order
NB. cols in defaultselection order
jdclocs=: 3 : 0
't c'=. ,each y
d=. getdb''
r=. ''
tables=. /:~NAMES__d
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

for_c. r do. NB. do the mapping
 if. _1=nc {.MAP__c,each <'__c' do.
   mapcolfile__c"0 MAP__c
   opentyp__c ''
 end.
end. 
r
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

jdcolsx=: 3 : 0
d=. getdb''
t=. getloc__d y
n=. NAMES__t
a=. CHILDREN__t
b=. (<'jdindex')~:2{.each n
n=. b#n
a=. b#a
(/:n){n,.a
)


jdserverstop=: 3 : 0
if. IFJHS do. OKURL_jhs_=: '' end.
)

NB. simple name treated as ~temp/jd/name
adminp=: 3 : 0
y=. jpathsep y
y=. y,~(-.'/'e.y)#'~temp/jd/'
y=. (-'/'={:y)}.y NB. no trailing /
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
yy=. y
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
 v=. fread y,'/jdversion'
 v=. (-.v-:_1){3,<.0".":v
 'db version not compatible with this Jd version'assert v=<.".jdversion
 'not a database'assert 'database'-:jdfread y,'/jdclass'
 'db damaged'assert (0=ftypex) y,'/jddamage'
 d=. }.(y i:'/')}.y
 
 'x'jdadminlk y NB. remove old lock (if any)
 'w'jdadminlk y
 
 NB. remove old admin for this folder
 dan=. (;(<jpath y)=jpath each {:"1 DBPATHS)#{."1 DBPATHS
 DBPATHS=: (-.({."1 DBPATHS)e.dan)#DBPATHS
 DBUPS=: (-.({."1 DBUPS)e.dan)#DBUPS
 DBOPS=: (-.({."1 DBOPS)e.dan)#DBOPS
 
 bak=. (<DBPATHS),(<DBUPS),<DBOPS
 c=. #DBPATHS
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
 NB. default access is for the 1st of the new dans
 jdaccess (;{.c{DBPATHS_jd_),' ',(;{:c{DBUPS_jd_),' intask'
 i.0 0
end.
)

jdadminx=: 3 : 0
yy=. y
y=. jpath adminp y
d=. }.(y i: '/')}.y
vdname d
i=. y i:'/'
f=. Open_jd_ i{.y
if. (<y)e.{:"1 jdadminlk_jd_'' do. NB. if locked, assume open, and should be dropped
 'x'jdadminlk y NB.! should be done after Drop - but there are problems
 Drop__f d
end.
jddeletefolder y
'w'jdadminlk y
Create__f d
jdversion fwrite y,'/jdversion'
jdadmin yy
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
DBPATHS=: (b#DBPATHS),((0~:#y),2)$(,x);y
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
 (LIBC,' close i i')cd y
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
'lock not a file' assert (2~:ftypex) f
if. ('x'~:{.x) *. -.fexist f do.'rw'fwrite f[jdcreatefolder y end.
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
 i.0 0['x'jdadminlk each _7}.each{:"1 LOCKED
case. do.
 assert 0['invalid argument'
end.
:
x lock y
i.0 0
)

NB. serious error (e.g., disk full)
NB. mark db as damaged - prevent any more ops on db
NB. signal error
jddamage=: 3 : 0
p=. '/jddamage',~dbpath DB
if. #y do.
 'damage'logtxt y
 'damage'logjd y
 y=. 'db marked as damaged - ',y,' - see doc technical|damaged'
 y fwrite p
 y assert 0
end.
ferase p
i.0 0 
)

3 : 0''
if. _1=nc<'DBPATHS' do. DBPATHS=: 0 2$'' end.
if. _1=nc<'DBUPS'   do. DBUPS=:   0 2$'' end.
if. _1=nc<'DBOPS'   do. DBOPS=:   0 2$'' end.
if. _1=nc<'LOCKED'  do. LOCKED=:  0 2$'' end.
LIBC=: unxlib'c'
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
 t=. 'mklink /D /J ',hostpathsep t
 jddeletefolder p
 shell t NB. wndows does junction between folders
else.
NB. !!! n=. '"',newp,'" "',(_5}.p),'"'
 n=. '"',newp,'" "',p,'"'
 t=. 'ln -s ',n
 jddeletefolder p
 shell t
end.
6!:3^:(2~:ftypex p) 0.1 NB. sometimes required in windows so next test works
'link failed' assert (2=ftypex) p
)

NB. report db link targets
jdlinktargets=: 3 : 0
if. IFWIN do.
 r=. <;._2 toJ shell 'dir /S "P"'rplc 'P';hostpathsep jdpath''
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
r=. ,LF,.~sptable links
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

NB. if jd'close' or jdadmin 0 fail, things are messes up, so try this
jdforce_clean=: 3 : 0
'NAMES_jd_'=: ''
unmapall_jmf_''
1 unmap_jmf_ each 0{"1 mappings NB. extra force
coerase conl 1
jdadmin 0
)

jdrt=: 3 : 0
aa=. 9}.each _8}.each tuts
demo=. _4}.each(>:;demos i:each'/')}.each demos
basic=. 'intro';'reads';'from';'admin';'csv';'csv_load';'join';'epochdt';'table_from_array'
advanced=. aa-.basic
y=. ,dltb y
if. y-:'' do.
 t=. <'  '
 r=.   (<'basic:'),t,each basic
 r=. r,(<'demo:'),t,each demo
 r=. r,(<'advanced:'),t,each advanced
 ;r,each LF
 return.
end.
t=. 'tutorial/',y,'_tut.ijs'
d=. 'demo/',y,'/',y,'.ijs'
if. (#tuts)>tuts i. <t do.
 spx JDP,t
elseif. (#demos)>demos i. <d do.
 spx JDP,d
elseif. 1 do.
 'invalid tutorial name'assert 0
end.
)
