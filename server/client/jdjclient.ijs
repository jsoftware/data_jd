NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. j curl access to jd server

require'~addons/ide/jhs/extra/man.ijs'
require'convert/pjson'
require'~addons/arc/lz4/lz4.ijs'

coclass'jdjclient'

man_jd_jclient=: 0 : 0
access jd server:
start J task 
   load'jd' NB. includes client
or   
   load'~addons/data/jd/server/client/jds/jdjclient.ijs' NB. just client

curl uses files that are in connect folder created by jdconnect
connect folder has unique (guid) name in its path

   cl=: jdconnect 'all user0/user0 localhost:3000'
   jdreq__cl   'info schema'
   jdclose__cl '' NB. logoff and delete connect folder

browse: https://localhost:3000

*** clear out dead connect folders
shell'kill -0 pid' fails if pid is invalid

)

ptemp=: jpath'~temp/jdclient/' NB. folder for temp postfile,resultfile,cookiefile

NB. shell that returns stderr
shellx=: 3 : 0
(shell :: '') y,' 2>',connect,'stderr'
fread connect,'stderr'
)

NB. get jds_cookie from cookiefile
getcookie=: 3 : 0
d=. fread COOKIEFILE
d=. (1 i.~ 'jds_cookie' E. d)}.d
d=. (d i. LF){.d
(>:d i. TAB)}.d
)

destroy=: 3 : 0
ferase 1 dir connect
rmdir_j_ }:connect
codestroy''
)

NB. jdconnect 'all user0/user0 localhost:3000'
jdconnect_z_=: 3 : 0
t=. <;._1 ' ',deb y
'not 3 blank delimited values: dan user/pswd host:port'assert 3=#t
'dan up host'=. t
cl=. conew'jdjclient'
cocurrent cl
connect=: ptemp,'/',~}:shell'uuidgen'
'mkdir failed' assert 1=mkdir_j_ connect
(":2!:6'')fwrite connect,'pid'
POSTFILE=:   hostpathsep connect,'postfile'
RESULTFILE=: hostpathsep connect,'resultfile'
COOKIEFILE=: hostpathsep connect,'cookiefile'
cookies=. ' -b "<COOKIEFILE>"  -c "<COOKIEFILE>" ' rplc '<COOKIEFILE>';COOKIEFILE
t=. 'curl --no-progress-meter <CERTS> --data-binary @"<POSTFILE>" -o "<RESULTFILE>" -X POST -H "Content-Type: application/octet-stream" '
HOST=: host
DAN=: dan
t=. t rplc '<POSTFILE>';POSTFILE;'<RESULTFILE>';RESULTFILE;'<CERTS>';;('localhost:'-:10{.host){'';'-k'
treq=:    t,cookies,' https://',HOST
('+ ',3!:1 'logon ',up)fwrite POSTFILE
r=. shellx treq
if. 0~:#r do. r assert 0[destroy'' end. 
if. 0=#getcookie'' do. 'logon failed' assert 0[destroy'' end.
cl
)

NB.! need to jdclose those with dead pids
jdclose=: 3 : 0
('- ',3!:1 'logoff')fwrite POSTFILE
shell treq
destroy''
i.0 0
)

NB. 'info summary'
NB. 'insert t';'a';23...
NB. reverse_proxy_binary.js adds jds_cookie to request passed to jds
NB. binary data transfered as lz4 jbin 
NB. cookie determines user from previous logon
NB. dan references the DB and has its own UPS and OPS
NB. implicit POSTFILE and RESULTFILE and COOKIEFILE
NB. POSTFILE avoids troubles with !>...
NB. result from jd server will be in lz4/jbin format
NB. some node results will be in json format
NB. see reqtest
jdreq=: 3 : 0
(DAN,' ',lz4_compressframe_jlz4_ 3!:1 y) fwrite POSTFILE
r=.  shellx treq
if. 0~:#r do. r assert 0[destroy'' end. 
r=. fread RESULTFILE
if. '{'={.r do. jsondec_pjson_ r return. end.
(3 !: 2) @ lz4_uncompressframe_jlz4_ r
)
