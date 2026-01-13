NB. Copyright 2025, Jsoftware Inc.  All rights reserved.

coclass'jdserver'
coinsert'jd'

jds_server_config_template=: 0 : 0
load'jd'
load RELOAD=: '~addons/data/jd/server/jds/jds_server_node.ijs'
LOGFILE_z_=:   '<PATH>jds/logfile.log' NB. z
UPFILE_jdup_=: '<PATH>upfile'
uctable_jdup_=: 0 2$'' NB. each row has cookie,user
PORT=: <PORT>
DBS=: jdremq_jd_ each ',' strsplit_jd_'<DBS>'

init''
)

NB. path;65220;0;'test,"foo,bar",~temp/jd/mum' - NB. PJDS global
create_jds=: 3 : 0
'path port dbs'=. y
sport=. ":port
f=. jpath path,'jds/'
mkdir_j_ f
log=. f,'log.log'
logstd=. f,'logstd.log' NB. stdout/stderr
ferase log;logstd
loglevel=. 0

t=. jds_server_config_template rplc '<PORT>';sport;'<DBS>';dbs;'<PATH>';path
t fwrite f,'run.ijs'

select. UNAME
case. 'Linux';'FreeBSD';'OpenBSD';'Darwin' do.
 t=. '#!/bin/bash',LF
 t=. t,'"BINPATH/jconsole" "SCRIPT"' rplc 'BINPATH';(jpath'~bin');'SCRIPT';f,'run.ijs'
 if. FHS do. t=. t rplc 'jconsole';'ijconsole' end.
 t fwrite f,'/run.sh'
 shell'chmod +x ',f,'run.sh'
 cmd=. ('nohup "PATHrun.sh" > "LOG" 2>&1') rplc 'PATH';f;'LOG';logstd
 cmd fwrite f,'run.txt'
case. 'Win' do.
 t=. 'for /f "tokens=5" %%a in (''netstat -aon ^| find ":',sport,'" ^| find "LISTENING"'') do taskkill /f /pid %%a' 
 t=. t,LF
 t=. ('/';'\')rplc~'"BINPATH/jconsole" "SCRIPT"' rplc 'BINPATH';(jpath'~bin');'SCRIPT';f,'run.ijs'
 t fwrite f,'run.bat'
 cmd=. ('"PATHrun.bat" > "LOG" 2>&1') rplc 'PATH';f;'LOG';logstd
 (cmd rplc '/';'\') fwrite f,'run.txt'
case. 'Darwin' do.
end.
f
)

NB. check if jds server y is running
check_jds=: 3 : 0
'server is not running on that port' assert _1~:pidfromport_jport_ y
)
