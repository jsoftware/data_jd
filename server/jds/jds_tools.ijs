NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB.    jdrt'jds'

require JDP,'server/port.ijs'

jdsfork=: 3 : 0
fork_jtask_ fread y,('/'#~'/'~:{:y),'run.txt'
)

jds_server_config_template=: 0 : 0
load '<JDP>jd.ijs'
load JDP,'server/jds/jds_server.ijs'
BASE=: <PORT>
LOGFILE_z_=: '<LOGFILE>'
LOGLEVEL_z_=: <LOGLEVEL>
DBS=: jdremq_jd_ each ',' strsplit_jd_'<DBS>'
init''
)

NB. path;65220;0;'test,"foo,bar",~temp/jd/mum' - NB. PJDS global
create_jds=: 3 : 0
'path port loglevel dbs'=. y
sport=. ":port
f=. jpath path,('/'#~'/'~:{:path),'jds/',sport,'/'
mkdir_j_ f
log=. f,'log.log'
logstd=. f,'logstd.log' NB. stdout/stderr
ferase log;logstd
loglevel=. 0

t=. jds_server_config_template rplc '<JDP>';JDP;'<PORT>';sport;'<LOG>';(":loglevel);'<LOGFILE>';log;'<DBS>';dbs
t fwrite f,'run.ijs'

select. UNAME
case. 'Linux' do.
 t=. '#!/bin/bash'
 t=. t,LF,'fuser -s -n tcp -k ',sport
 t=. t,LF,'"BINPATH/jconsole" "SCRIPT"' rplc 'BINPATH';(jpath'~bin');'SCRIPT';f,'run.ijs'
 t fwrite f,'/run.sh'
 shell'chmod +x ',f,'run.sh'

 cmd=. ('setsid "PATHrun.sh" > "LOG" 2>&1') rplc 'PATH';f;'LOG';logstd
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