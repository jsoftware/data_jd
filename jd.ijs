NB. Copyright 2018, Jsoftware Inc.  All rights reserved.

0 : 0
package manager Jd library is ~addons/data/jd
   load'data/jd' NB. 'data/jd/jd.ijs'

production Jd application should run from dedicated folder to avoid pacman updates
   load'~/production/jd/jd.ijs'

git developer Jd library is ~Jddev (~config/folders.cfg)
  load'~Jddev/jd.ijs'

all use is through JDP_z_ (set when the library is loaded)
)

coclass'jd'
jdversion=: '4.32'

doin=: 4 : '(<x)(4 : ''do__y x'')each<"0 y' NB. run sentence in each locale

'Jd requires J807 or later'assert 807<:0".}.4{.9!:14''
'Jd requires J64'assert IF64=1
('Jd not supported on UNAME: ',UNAME) assert (<UNAME)e.'Win';'Linux';'Darwin' 
'Jd requires addon jfiles'assert fexist '~addons/data/jfiles/jfiles.ijs'
require'jfiles'
require'data/jmf'
require'convert/pjson'

missingkey=: '!!! Jd key: non-commercial key automatically installed'
noncomkey=:  '!!! Jd key: non-commercial use only!'
invalidkey=: '!!! Jd key: invalid'
updatekey=:  '!!! Jd key: expired - restore earlier version or get new key'
fkey=:   '~config/jdkey.txt'
noncom=: 'a11544796265500412' NB. validation bug sometimes needs blank at end

3 : 0''
k=. fread fkey
if. (_1=k)+.(<3{.}.(k i.' ')}.k)e.;:'edu eva' do.
 echo missingkey
 'non_commercial key install failed'assert (>:#noncom)=(noncom,' ') fwrite fkey
else.
 if. noncom-:k-.' ' do. echo noncomkey else. echo '!!! Jd key:',(k i.' ')}.k end.
end. 

if. IFWIN do.
 'Jd requires Windows version > XP'assert 5<{:,(8#256)#:;'kernel32.dll GetVersion x' cd ''
 try. 'msvcr120.dll foo x'cd'' catch. end.
 t=. 'Jd requires msvcr120.dll',LF,'http://www.microsoft.com/en-ca/download/details.aspx?id=40784',LF,'download vcredist_x64.exe and run to install msvcr110.dll'
 t assert 2 0=cder''
end.

NB. ensure different (production vs development) Jd libraries are not both loaded
n=. '/jd.ijs'
d=. jpath each 4!:3''
f=. (;(<n)-:each (-#n){.each d)#d
'can not mix different Jd libraries' assert 1=#f
JDP_z_=: _6}.;f

t=. jpath JDP,'cd/'
if. UNAME-:'Linux' do.
 t=. t,IFRASPI{::'libjd.so';'rpi/libjd.so'
elseif. UNAME-:'Darwin' do.
 t=. t,'libjd.dylib'
elseif. 1 do.
 if. _1=nc<'DLLDEBUG__' do.
  t=. t,'jd.dll'
 else.
  t=. '/users/eric/git/jd-cdsrc/makevs/x64/debug64/jddll.dll' NB. ms visual studio debug
  echo t
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

LIBJD=: '"',t,'"'
JDT=: (LIBJD,' jdinit >x') cd '' NB. get jdt
r=. (LIBJD,' jdlicense >x x *c') cd JDT;<jpath'~config'
if. _1=r do. assert 0[echo invalidkey end.
NB. if. _2=r do. assert 0[echo evalkey end.
if. _3=r do. assert 0[echo updatekey end.
'Jd binary and J code mismatch - bad install'assert r=8 NB. 7 - jd3 and 8 -jd4
'Jd regexinit failed'assert 0=(LIBJD,' regexinit >x x *c') cd JDT;<q 
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
base/fixpairs.ijs
base/column.ijs
base/constants.ijs
base/keyindex.ijs
base/read.ijs
base/where.ijs
base/jmfx.ijs
base/lock.ijs
base/log.ijs
base/validate.ijs
tools/setscriptlists.ijs
api/api.ijs
api/api_adm.ijs
api/api_blob.ijs
api/api_change.ijs
api/api_create.ijs
api/api_csv.ijs
api/api_csvcdefs.ijs
api/api_drop.ijs
api/api_gen.ijs
api/api_info.ijs
api/api_misc.ijs
api/api_read.ijs
api/api_rename.ijs
api/api_replicate.ijs
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
load JDP,'tools/tests.ijs'
jdtests y
)

repair=: 3 : 0
load JDP,'tools/repair.ijs'
repair''
)

3 : 0''
IFTESTS=: 0
if. _1=nc<'OP' do. NB. one time inits
 JDMT=: MTRW_jmf_
 JDMTMRO=: 0 NB. not an mtm ro task
 FEOP=: OP=: 'none'
 TEMPCOLS=: i.0 2
 LOGOPS=: 0 NB. do not log ops
 cntsclear''
 FORCEVALIDATEAFTER=: 0
 FORCEREVERT=: 0
 FORCELEFT=: 0  NB. force all refs to be /left for testing
 PMON=: 0       NB. performance monitor not recording
 PMN=: PMT=: '' NB. no records
 PMMR=: 100     NB. max records kept
end.
ULIMIT=: ''
if. -.UNAME-:'Win' do.
 n=. ".}:2!:0'ulimit -n'
 if. n<1024 do.
  ULIMIT=: LF,~LF,'Warning: ',(":n),' for "ulimit -n" is low. See Technotes|file handles.'
 end. 
end.
ifintel=: 'a'={.2 ic a.i.'a' NB. endian
)

jdwelcome=: 0 : 0 rplc 'BOOKMARK';(jpath JDP,'doc/Index.htm');'ULIMIT';ULIMIT
Jd is Copyright 2019 by Jsoftware Inc. All Rights Reserved.
Jd is provided "AS IS" without warranty or liability of any kind.

All use must be under a Jd License:
https://code.jsoftware.com/wiki/Jd/License

All files in Jd application folder, unless otherwise noted, are:
Copyright 2019, Jsoftware Inc.  All rights reserved.

Wiki documentation of the latest version is at:
https://code.jsoftware.com/wiki/Jd/Index

A listing of a run of all the latest tutorials is at:
https://www.jsoftware.com/jd_tuts.html

Snapshot of the Jd wiki for this release is at: 
file://BOOKMARK
ULIMIT
Get started:
   jdrt '' NB. tutorials
)

echo'   jdwelcome_jd_ NB. run this sentence for important information'
