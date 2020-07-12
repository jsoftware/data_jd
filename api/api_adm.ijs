NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

jdadmin_z_   =: jdadmin_jd_
jdadminnew_z_=: jdadminnew_jd_
jdadminx_z_  =: jdadminx_jd_
jdadminro_z_ =: jdadminro_jd_

coclass'jd'

NB. jd... verbs assert expected error (similar to jdae)
jdadmae_jd_=: 4 : 0
t=. 13!:12''
assert 'assertion failure'-:y
assert +./x E. t
t=. (t i. LF){.t
}.(t i:':'){.t
)

jdpath=:  3 : 'jpath jdpathx y'
jdpathx=: 3 : '(dbpath DB),''/'',y'

assertnodamage=: 3 : 0
p=. <jdpath''
'db damaged and not under repair' assert -.1 0-:fexist p,each'jddamage';'jdrepair'
)

getdb=: 3 : 0
assertnodamage''
db=. dbpath DB
'not database class'assert 'database'-:jdfread db,'/jdclass'
i=. db i:'/'
f=. Open_jd_ jpath i{.db
dbl=: Open__f (>:i)}.db
)

NB. table names,.locales sorted by name
jdtables=: 3 : 0
n=. NAMES__dbl
a=. CHILDREN__dbl
(/:n){n,.a
)

NB. y is t;c
NB. t is '' for all tables  or 'tab' for just that table
NB. c is '' for all cols    or 'col' for just that col
NB. tables  in sorted order
NB. cols in defaultselection order
NB. x 1 does mapcolfile
jdclocs=: 3 : 0
0 jdclocs y
:
't c'=. ,each y
r=. ''
tables=. /:~NAMES__dbl
if. #t do.
 'not a table' assert NAMES__dbl e.~ <t
 tables=. <t
end. 
tablelocs=. ''

NB. table children may not be open - getloc forces open
for_n. tables do.
 tablelocs=. tablelocs,getloc__dbl n
end. 

for_i. i.#tables do.
 t=. i{tablelocs
 if. #c do.
  'not a column' assert NAMES__t e.~ <c
  cols=. <c
 else. 
  cols=. getdefaultselection__t''
  cols=. cols,(bjdn NAMES__t)#NAMES__t
 end.
 r=. r,(NAMES__t i. cols){CHILDREN__t
end.

if. x do.
 for_c. r do. NB. do the mapping
  if. _1=nc {.MAP__c,each <'__c' do.
    mapcolfile__c"0 MAP__c
    opentyp__c ''
  end.
 end. 
end. 
r
)

NB. non-system col names,.locales sorted by name
jdcols=: 3 : 0
t=. getloc__dbl y
n=. NAMES__t
a=. CHILDREN__t
b=. -.bjdn n
n=. b#n
a=. b#a
(/:n){n,.a
)

jdcolsx=: 3 : 0
t=. getloc__dbl y
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
if. ''-:y do.
 t=. (jdadminfp''),(jdadminup''),(jdadminop''),jdadminlk''
 (/:{."1 t){t
elseif. 0-:y do.
 JDMT=: 0
 jd_close''
 jdadminlk 0
 jdadminfp 0
 jdadminup 0
 jdadminop 0
 jdaccess 0
 i.0 0
elseif. 1 do.
 adminopen y
end.
:
select. x
case. 'new' do. jdadminx y
case. 'access' do.
 'bad y'assert ''-:y
 d=. {."1 jdadmin''
 d=. /:~~.d#~;'['~:;{.each d
 m=. (d=<DB){' ''';'['''
 d=. >(<'   jdaccess'),each m,each d,each''''
case. do. 'bad x'assert 0
end.
)

adminopen=: 3 : 0
 if. 0=L.y do. mt=. 0 else. 'y mt'=. y end.
 y=. adminp y
 'not a folder'assert 2=ftype y
 'not a database'assert 'database'-:jdfread y,'/jdclass'
 v=. fread y,'/jdversion'
 v=. (-.v-:_1){3,<.0".":v
 'db version not compatible with this Jd version'assert v=<.".jdversion
 'invalid map type' assert mt e. i.3
 locktype=. mt{'wrc'
 t=. {:"1 jdadminlk''
 i=. t i. <jpath y
 if. i<#t do. NB. already open - just do access to first dan for the db
  'reopen must have same map type' assert JDMT=mt
  i=. (jpath each {:"1 DBPATHS)i.<jpath y
  jdaccess (;{.i{DBPATHS_jd_),' ',(;{:i{DBUPS_jd_),' intask'
  i.0 0
  return.
 end. 
 'multiple open dbs must all be MTRW' assert (0=#DBPATHS)+.(mt=0)*.JDMT=0
 t=. 3!:2 ::((0 2$'')"_) fread y,'/jdstate'   NB. ok if jdstate is missing
 i=. ({."1 t)i.<'RLOGFOLDER'
 if. i~:#t do.
  a=. ;{:i{t
  t=. 'rlog',~jpath a
  ('replicate folder ''',a,''' is in use')assert -.(<hostpathsep t) e. {:1!:20''
 end.
 
 locktype jdadminlk y

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
 getdb'' NB. set dbl
 JDMT=: mt
 i.0 0
)

jdadminnew=: 3 : 0
'new'jdadmin y
)

jdadminx=: 3 : 0
'y must not be empty'assert 0~:#y
yy=. y
y=. jpath adminp y
d=. }.(y i: '/')}.y
vdname d
i=. y i:'/'
f=. Open_jd_ i{.y
if. (<y)e.{:"1 jdadminlk_jd_'' do. NB. if locked, assume open, and should be dropped
 'x'jdadminlk y NB. should be done after Drop - but there are problems
 Drop__f d
end.
jddeletefolder y
'w'jdadminlk y
Create__f d
'x'jdadminlk y
jdadmin yy
)

dbrow=: 3 : '({."1 y)i.<DB'

admind=: 4 : 0
db=. x-.' '
assert 0~:#db['DB empty'
db;<deb y rplc LF,' '
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

NB. jdadminlk'' is query on lock state
NB. adminlk 0 frees all locks
NB. type adminlk path
NB. type is 'w' 'r' or 'x' unlock
NB. lock is on a file in the database folder
jdadminlk=: 3 : 0
select. y
case. '' do.
 ((0=;{."1 LOCKED_jd_){'[w]';JDMT{'[w]';'[r]';'[c]'),._7}.each{:"1 LOCKED
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
if. 0~:JDMT do. 'RO/CW db serious error - but db not marked as damaged'assert 0 end.
p=. 'jddamage',~jdpath''
if. #y do.
 'damage'logtxt y
 'damage'logjd y
 y=. 'db marked as damaged - ',y,' - see doc technical|damaged'
 y fwrite p
 y assert 0
end.
ferase p
ferase 'jdrepair',~jdpath''
i.0 0 
)

NB. jdrepair 'reason' - mark damaged db as under repair
NB. jdrepair ''       - unmark
jdrepair=: 3 : 0
p=. jdpath''
if. #y do.
 y fwrite p,'/jdrepair'
else.
 ferase p,'/jdrepair'
end.
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
 r=. <;._2 toJ shell 'ls -l -R "P"'rplc 'P';jpath jdpath''
 r=. ((<'lrw')=3{.each r)#r
 (r i.each'/')}.each r
end.
)

NB. set links.txt in database folder
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
a=. bdnames y
if. 1=#a do.
 getloc__dbl ;a
else.
 t=. getloc__dbl ;{.a
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

NB. if jd'close' or jdadmin 0 fail, things are messed up, so try this
jdforce_clean=: 3 : 0
'NAMES_jd_'=: ''
unmapall_jmf_''
1 unmap_jmf_ each 0{"1 mappings NB. extra force
coerase conl 1
jdadmin 0
)

NB. add y defns to custom.ijs and reload it
jdloadcustom=: 3 : 0
p=. jdpath_jd_'custom.ijs' 
if. #y do. y fappend p end.   
load__dbl p
)

jdcsvfolder=: 3 : 0
CSVFOLDER__=: PATH__dbl,'jdcsv/'
jdcreatefolder CSVFOLDER__
'csv'fwrite CSVFOLDER__,'jdclass'
i.0 0
)