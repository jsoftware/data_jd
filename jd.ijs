NB. Copyright 2026, Jsoftware Inc.  All rights reserved.

NB. only 1 code base is loaded
n=. '/jd.ijs'
d=. jpath each 4!:3''
f=. (;(<n)-:each (-#n){.each d)#d
('Jd can not be loaded from different folders',LF,;f,each LF)assert 1=#f
JDP_z_=: _6}.;f

coclass'jd'
jdversion=: '4.48'

jdwelcome=: 0 : 0
Jd is Copyright 2026 by Jsoftware Inc. All Rights Reserved.
Jd is provided "AS IS" without warranty or liability of any kind.
License required: https://code.jsoftware.com/wiki/Jd/License

*** 4.48 (jd'list version') is a major upgrade
most changes are upward compatible - proceed with caution!

*** server-client support is completely new
   jdrt'server-client' NB. list server-client tutorials

tutorials relevant to server performance:
   jdrt'each'   NB. list of ops to perform in one request
   jdrt'custom' NB. custom op to perform transaction

*** man system
wiki pages have not been updated for 4.48
latest is documented in the tutorials and with man
man docs are at your fingertips and are in the script with the code
   man''         NB. list mans that cover a topic
   man'jd'       NB. doc that preceeds jd=:
   man'jdserver' NB. doc that preceeds jdserver=:

*** wiki - https://code.jsoftware.com/wiki/Jd/Index

*** get started
   jdrt '' NB. tutorials
)

man_jd_a_welcome=: jdwelcome_jd_

man_jd_b_users=: 0 : 0
direct access users do not have passwords
   jdaccess dan;user NB. validate user/op against admin.ijs

server requires logon with user and a pswd
   jdrt'user_pswd'
)

doin=: 4 : '(<x)(4 : ''do__y x'')each<"0 y' NB. run sentence in each locale

'Jd requires J807 or later'assert (807<:0".}.4{.9!:14'')+.3=4!:0<'revinfo_j_'
'Jd requires J64'assert IF64=1
('Jd not supported on UNAME: ',UNAME) assert (<UNAME)e.'Win';'Linux';'FreeBSD';'OpenBSD';'Darwin'
'Jd requires addon jfiles'assert fexist '~addons/data/jfiles/jfiles.ijs'
require'jfiles'
require'data/jmf'
require'convert/pjson'
require'~addons/ide/jhs/extra/man.ijs'
require'~addons/ide/jhs/port.ijs'
require'~addons/net/jcs/jcs.ijs'
erase'jd_jcs_' NB. avoid man duplicate

3 : 0''
if. IFWIN do.
 'Jd requires Windows version > XP'assert 5<{:,(8#256)#:;'kernel32.dll GetVersion x' cd ''
 NB. try. 'msvcr120.dll foo x'cd'' catch. end.
 NB. t=. 'Jd requires msvcr120.dll',LF,'http://www.microsoft.com/en-ca/download/details.aspx?id=40784',LF,'download vcredist_x64.exe and run to install msvcr110.dll'
 NB. t assert 2 0=cder''
end.

NB. sever requires setsid so jds and node task will not end when the start task ends
NB. setsid is not in mac so we provide our own universal binary from github
SETSID=: ;(UNAME-:'Darwin'){'setsid';jpath JDP,'/cd/setsid/setsid'

t=. jpath JDP,'cd/'
if. (<UNAME)e.'Linux';'FreeBSD';'OpenBSD' do.
 t=. t,IFRASPI{::'libjd.so';'rpi/libjd.so'
elseif. UNAME-:'Darwin' do.
 t=. t,'libjd.dylib'
elseif. 1 do.
 if. _1=nc<'DLLDEBUG__' do.
  t=. t,('arm64'-:9!:56'cpu'){::'jd.dll';'jd-arm64.dll'
 else.
  t=. jpath'~/git/jd-cdsrc/makevs/x64/debug64/jddll.dll' NB. visual studio debug
  echo t
 end.
end.
'Jd share library missing'assert fexist t

NB. Jd must continue to use pcre library - work is required to make use of the new pcre2 library
select. UNAME
case. 'Linux';'FreeBSD';'OpenBSD' do. q=. (IFRASPI#'rpi/'),'libjpcre.so'
case. 'Darwin' do. q=. 'libjpcre.dylib'
case.          do. q=. ('arm64'-:9!:56'cpu'){::'jpcre.dll';'jpcre-arm64.dll'
end.
q=. q,~JDP,'cd/'
'Jd pcre library missing'assert fexist q

LIBJD=: '"',t,'"'
JDT=: (LIBJD,' jdinit >x') cd '' NB. get jdt

k=. fread '~config/jdkey.txt'
if. _1-:k do.
 pk=. }:JDP NB. no key or old free key map to JDP,'jdkey.txt'
 echo '!!! Jd key: non-commercial use only!'
else.
 pk=. '~config'
 echo '!!! Jd key:',(k i.' ')}.k
end. 

r=. (LIBJD,' jdlicense >x x *c') cd JDT;<jpath pk
'!!! Jd key: ~config/jdkey.txt is invalid - erase to use a free non-commercial key' assert r>0
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
base/parse.ijs
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
tools/csv_load.ijs
tools/python3.ijs
api/api.ijs
api/api_adm.ijs
api/api_blob.ijs
api/api_change.ijs
api/api_create.ijs
api/api_csv.ijs
api/api_csvcdefs.ijs
api/api_drop.ijs
api/api_dup.ijs
api/api_gen.ijs
api/api_info.ijs
api/api_misc.ijs
api/api_read.ijs
api/api_rename.ijs
api/api_replicate.ijs
api/api_sort.ijs
api/api_table.ijs
csv/csv.ijs
csv/csvinstall.ijs
dynamic/base.ijs
dynamic/ref.ijs
server/manager.ijs
server/client/jclient.ijs
tools/tests.ijs
types/base.ijs
types/numeric.ijs
types/autoindex.ijs
types/byte.ijs
types/datetimes.ijs
types/epoch.ijs
types/varbyte.ijs
)

repair=: 3 : 0
load JDP,'tools/repair.ijs'
repair''
)

get_handle_limits=: 3 : 0
LIBC=: unxlib'c'
RLIMIT_NOFILE=: ('Darwin'-:UNAME){7,8 NB. assume rpi has linux value
MAX_OPEN=: 10240*>:-.'Darwin'-:UNAME NB. macos hardwired 10420, linux higher
;{:(LIBC,' getrlimit i i *x') cd RLIMIT_NOFILE;0 0
)

set_handle_limit=: 3 : 0
r=. get_handle_limits''
;{.(LIBC,' setrlimit i i *x') cd RLIMIT_NOFILE;y,{:r
)

3 : 0''
if. _1=nc<'jdscpath' do. jdscpath=: jpath '~/jdscpath/' end. NB. path to all server/client files
IFTESTS=: 0
if. _1=nc<'OP' do. NB. one time inits
 IFJDS_z_=: 0
 oplogdata=: '' NB. performance data
 jdaccess '';''
 JDMT=: MTRW_jmf_
 JDMTMRO=: 0 NB. not an mtm ro task
 FEOP=: OP=: 'none'
 TEMPCOLS=: i.0 2
 LOGOPS=: 0 NB. do not log ops
 log_size_limit=: 16e6 NB. applies to all logs (logtxt abd jdslog)
 cntsclear''
 FORCEVALIDATEAFTER=: 0
 FORCEREVERT=: 0
 FORCELEFT=: 0  NB. force all refs to be /left for testing
 PMON=: 0       NB. performance monitor not recording
 PMN=: PMT=: '' NB. no records
 PMMR=: 100     NB. max records kept
end.
if. -.UNAME-:'Win' do.
 r=. get_handle_limits''
 if. MAX_OPEN>{.r do. set_handle_limit MAX_OPEN end.
 r=. {.get_handle_limits''
 if. r<10240 do. echo LF,~LF,~LF,'Warning: ',(":r),' for limit on number of file handles is low. See Technotes|file handles.' end. 
end.
ifintel=: 'a'={.2 ic a.i.'a' NB. endian
)

NB. from JHS
seebox=: 3 : 0
1 seebox y
:
;((x+>./>#each y){.each "1 y),.<LF
)

3 : 0''
if. IFUNIX do.
 t=. -.+./'->'E. shell 'ls -l ',}:JDP
else.
 +.a.
end. 
m=. {{)n
casual use is OK from pacman folder (pacman can update!)
   
serious use requires non-pacman folder
copy ~addons/data/jd to ~/jdprod and symlink ~addons/data/jd to ~/jdprod
   load'jd' NB. load jdprod code
}}
echo (t*.(JDP-:'/',~jpath'~addons/data/jd'))#LF,m,LF
echo (20<#1 1    dir jdscpath_jd_,'client')#LF,LF,~LF,~'warning: folder jdscpath/client may need attention'
echo'   jdwelcome_jd_ NB. run this sentence for important information'
)
