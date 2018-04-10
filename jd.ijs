NB. Copyright 2017, Jsoftware Inc.  All rights reserved.

NB. production Jd library is ~addons/data/jd (installed/updated by JAL)
NB.   load'data/jd' NB. set JDP_z_ as path to production Jd library

NB. developer Jd library is ~Jddev (~config/folders.cfg)
NB.   load'~Jddev/jd.ijs' NB. set JDP_z_ as developer Jd library
NB. ~Jddev copied (based on manifest.ijs) to svn repo that
NB. is pushed to Jsoftware for building JAL data/jd package

NB. all use of the Jd library is through JDP_z_

jdversion_jd_=: '4.13'

nokey_jd_=: 0 : 0 rplc 'INDEX.HTM';jpath '~addons/data/jd/doc/Index.htm'

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Jd key: missing or invalid
http://code.jsoftware.com/wiki/Jd/License

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

)

evalkey_jd_=: 0 : 0

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Jd key: evaluation period expired

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

)

updatekey_jd_=: 0 : 0

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Jd key: not valid for this version
restore to earlier version or get new key

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

)

3 : 0''
if. 10~:#CRLF-.~fread jpath'~config/jdkey.txt' do. return. end.
assert 0[echo updatekey_jd_
)

'Jd requires J64'assert IF64=1
('Jd not supported on UNAME: ',UNAME) assert (<UNAME)e.'Win';'Linux';'Darwin' 
'Jd requires addon jfiles'assert fexist '~addons/data/jfiles/jfiles.ijs'
require'jfiles'
require'data/jmf'

echo (t i.' ')}.t=. fread'~config/jdkey.txt'

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
if. UNAME-:'Linux' do.
 t=. t,IFRASPI{::'libjd.so';'rpi/libjd.so'
elseif. UNAME-:'Darwin' do.
 t=. t,'libjd.dylib'
elseif. 1 do.
 if. _1=nc<'DLLDEBUG__' do.
  t=. t,'jd.dll'
 else.
  t=. t,'../cdsrc/makevs/x64/debug64/jddll.dll' NB. ms visual studio debug
 end.
end.
'Jd share library missing'assert fexist t

NB. Jd must continue to use pcre library - work is required to make use of the new pcre2 library
select. UNAME
case. 'Linux'  do. q=. (IFRASPI#'rpi/'),'libjpcre.so'
case. 'Darwin' do. q=. 'libjpcre.dylib'
case.          do. q=. 'jpcre.dll'
end.
q=. q,~JDP,'cd/'
'Jd pcre library missing'assert fexist q

LIBJD_jd_=: '"',t,'"'
r=. (LIBJD_jd_,' jdinit >x *c') cd <jpath'~config'
if. _1=r do. assert 0[echo nokey_jd_ end.
if. _2=r do. assert 0[echo evalkey_jd_ end.
if. _3=r do. assert 0[echo updatekey_jd_ end.
'Jd binary and J code mismatch - bad install'assert r=8 NB. 7 - jd3 and 8 -jd4
'Jd regexinit failed'assert 0=(LIBJD_jd_,' regexinit >x *c') cd <q 
)

load@:(JDP&,);._2 ]0 :0
base/util_epoch.ijs
base/util_ptable.ijs
base/util.ijs
base/zutil.ijs
base/pm.ijs
base/common.ijs
base/folder.ijs
base/database.ijs
base/table.ijs
base/column.ijs
base/constants.ijs
base/keyindex.ijs
base/read.ijs
base/where.ijs
base/jmfx.ijs
base/log.ijs
base/validate.ijs
api/api.ijs
api/api_adm.ijs
api/api_change.ijs
api/api_create.ijs
api/api_csv.ijs
api/api_drop.ijs
api/api_gen.ijs
api/api_info.ijs
api/api_misc.ijs
api/api_read.ijs
api/api_rename.ijs
api/api_sort.ijs
api/api_table.ijs
api/client.ijs
csv/csv.ijs
csv/csvinstall.ijs
dynamic/base.ijs
dynamic/ref.ijs
types/base.ijs
types/numeric.ijs
types/autoindex.ijs
types/byte.ijs
types/datetimes.ijs
types/epoch.ijs
types/varbyte.ijs
)

NB. stubs to load scripts not normally loaded
jdtests=: 3 : 0
0 jdtests y
:
load JDP,'tools/tests.ijs'
jdtests_jd_ y
)

repair_jd_=: 3 : 0
load JDP,'tools/repair.ijs'
repair_jd_''
)

setscriptlists_jd_=: 3 : 0
load JDP,'tools/setscriptlists.ijs'
setscriptlists_jd_''
)

3 : 0''
IFTESTS_jd_=: 0
if. _1=nc<'OP_jd_' do. NB. one time inits
 FEOP_jd_=: OP_jd_=: 'none'
 TEMPCOLS_jd_=: i.0 2 
 cntsclear_jd_''
 FORCEVALIDATEAFTER_jd_=: 0
 FORCEREVERT_jd_=: 0
 FORCELEFT_jd_=: 0  NB. force all refs to be /left for testing
 PMON_jd_=: 0       NB. performance monitor not recording
 PMN_jd_=: PMT_jd_=: '' NB. no records
 PMMR_jd_=: 100     NB. max records kept
end.
ULIMIT_jd_=: ''
if. -.UNAME-:'Win' do.
 n=. ".}:2!:0'ulimit -n'
 if. n<1024 do.
  ULIMIT_jd_=: LF,~LF,'Warning: ',(":n),' for "ulimit -n" is low. See Technotes|file handles.'
 end. 
end.
ifintel_jd_=: 'a'={.2 ic a.i.'a' NB. endian
)

jdwelcome=: 0 : 0 rplc 'BOOKMARK';(jpath JDP,'doc/Index.htm');'ULIMIT';ULIMIT_jd_
Jd is Copyright 2018 by Jsoftware Inc. All Rights Reserved.
Jd is provided "AS IS" without warranty or liability of any kind.

All use must be under a Jd License from Jsoftware.

Wiki documentation of the latest version of Jd is at:
 http://code.jsoftware.com/wiki/Jd/Index

Snapshot of the Jd wiki for this release is at: 
 file://BOOKMARK
ULIMIT
Get started:
   jdrt''      NB. list tutorials
)

echo'   jdwelcome NB. run this sentence for important information'
