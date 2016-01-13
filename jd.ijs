NB. Copyright 2014, Jsoftware Inc.  All rights reserved.

NB. production Jd library is ~addons/data/jd (installed/updated by JAL)
NB.   load'data/jd' NB. set JDP_z_ as path to production Jd library

NB. developer Jd library is ~Jddev (~config/folders.cfg)
NB.   load'~Jddev/jd.ijs' NB. set JDP_z_ as developer Jd library
NB. ~Jddev copied (based on manifest.ijs) to svn repo that
NB. is pushed to Jsoftware for building JAL data/jd package

NB. all use of the Jd library is through JDP_z_

nokey_jd_=: 0 : 0 rplc 'INDEX.HTML';jpath '~addons/data/jd/doc/index.html'

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Jd key: missing or invalid
email: jdinfo@jsoftware.com
to provide basic info and request a key

non-commercial or evaluation key is free
and does not require a license agreement

See Jd documentation at:
INDEX.HTML

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

)

'Jd requires J64'assert IF64=1
('Jd not supported on UNAME: ',UNAME) assert (<UNAME)e.'Win';'Linux';'Darwin' 
'Jd requires addon jfiles'assert fexist '~addons/data/jfiles/jfiles.ijs'
require'jfiles'
require'data/jmf'
require'~addons/ide/jhs/sp.ijs'

3 : 0''
if. 0*.IFWIN do.
 'Jd requires Windows version > XP'assert 5<{:,(8#256)#:;'kernel32.dll GetVersion x' cd ''
 try. 'msvcr110.dll foo x'cd'' catch. end.
 t=. 'Jd requires msvcr110.dll',LF,'http://www.microsoft.com/en-ca/download/details.aspx?id=30679',LF,'download vcredist_x64.exe and run to install msvcr110.dll'
 t assert 2 0=cder''
end.

NB. ensure different (production vs development) Jd libraries are not both loaded
n=. '/jd.ijs'
d=. jpath each 4!:3''
f=. (;(<n)-:each (-#n){.each d)#d
'can not mix different Jd libraries' assert 1=#f
JDP_z_=: _6}.;f
)

3 : 0''
t=. jpath JDP,'cd/'
p=. jpath'~tools/regex/'
if. UNAME-:'Linux' do.
 t=. t,'libjd.so'
 p=. p,'libjpcre.so'
elseif. UNAME-:'Darwin' do.
 t=. t,'libjd.dylib'
 p=. p,'libjpcre.dylib'
elseif. 1 do.
 if. _1=nc<'DLLDEBUG__' do.
  t=. t,'jd.dll'
 else.
  t=. t,'../cdsrc/makevs/x64/debug64/jddll.dll' NB. ms visual studio debug
 end.
  p=. (p,'jpcre.dll')rplc'/';'\'
end.
LIBJD_jd_=: '"',t,'"'
if. _1=r=. (LIBJD_jd_,' jdinit >x *c') cd <JDP_jd_ do. assert 0[echo nokey_jd_ end.
'Jd binary and J code mismatch - bad install'assert r=6
'Jd regexinit failed'assert 0=(LIBJD_jd_,' regexinit >x *c') cd <p 
)

load@:(JDP&,);._2 ]0 :0
base/util_epoch.ijs
base/util.ijs
base/zutil.ijs
base/pm.ijs
base/common.ijs
base/folder.ijs
base/database.ijs
base/table.ijs
base/column.ijs
base/read.ijs
base/where.ijs
base/jmfx.ijs
base/log.ijs
base/scriptlists.ijs
base/tests.ijs
base/validate.ijs
api/api.ijs
api/api_adm.ijs
api/api_change.ijs
api/api_csv.ijs
api/api_drop.ijs
api/api_info.ijs
api/client.ijs
csv/csv.ijs
csv/csvinstall.ijs
)

loadall =: (''&$:) : (4 : 0)
y =. (,'/'-.{:) jpath y
load (<y) ,&.> (boxxopen x) ~.@, {."1 ]1!:0 y,'*.ijs'
)

(<;._1' base.ijs numeric.ijs') loadall JDP,'types/'
(<;._1' base.ijs hash1.ijs hash.ijs')    loadall JDP,'dynamic/'
erase'loadall'

NB. initial globals
3 : 0''
APIRULES_jd_=:  1
ALLOW_FVE_jd_=: 0 NB. 1 allows hash float - see test/api_float.ijs
if. _1=nc<'OP_jd_' do. NB. one time inits
 FEOP_jd_=: OP_jd_=: 'none'
 TEMPCOLS_jd_=: i.0 2 
 cntsclear_jd_''
 pmclear_jd_''
 FLUSHAUTO_jd_=: 1 NB. flush done in close and after create... ref reference set
 FORCEVALIDATEAFTER_jd_=: FORCEREVERT_jd_=: 0
end.
)

jdwelcome_jd_=: 0 : 0 rplc 'BOOKMARK';jpath JDP,'doc/index.html'
Jd is Copyright 2015 by Jsoftware Inc. All Rights Reserved.
Jd is provided "AS IS" without warranty or liability of any kind.

Commercial users must have a Jd License from Jsoftware.

Keep addons (base, JHS, jmf, etc) up to date.

There is a slight bias for JHS as the front end.
JHS is the base technology for Jd client/server.

JAL does not lock against other tasks using the same Jd folder.
Update with tasks using the same Jd folder will cause problems.

Different J installs should be used for production systems and
development systems.

Bookmark documentation in your browser:
   file:///BOOKMARK

Get started:
   jdtests_jd_''   NB. validate install/update - takes minutes
   jdex_jd_''      NB. list examples from user.html
   jdex_jd_'reads' NB. run reads
   jdrt_jd_''      NB. list tutorials
   jdrt_jd_'intro' NB. run intro
)

3 : 0''
new=. ;{:jd'list version'
old=. fread'~temp/jd/jdversion'
if. new-:old do.
 echo'   jdwelcome_jd_ NB. Jd welcome message'
else.
 echo jdwelcome_jd_
 echo LF,'new install or new version - run jdtests!'
end. 
)

3 : 0''
if. -.UNAME-:'Win' do.
 n=. ".}:2!:0'ulimit -n'
 if. n<200000 do.
  echo LF,'Warning: ',(":n),' for "ulimit -n" is low. See Technotes|file handles.'
 end.
end.
)
