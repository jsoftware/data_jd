NB. script template to start server
jcs_start_template=: 0 : 0
load'~addons/net/jcs/jcs.ijs'
load'jd'
ADMIN
SERVER=: jcss 'PORT'
su__SERVER=: 'SU'
rpc__SERVER=: rpcjd
echo'OK'
runserver__SERVER''
)

NB. create server start script
NB. file;port;su;admin
NB. port 65200 or '65200' is localhost only - '*:65200' is bind any
jcs_start_fix=: 3 : 0
'file port su admin'=. y
echo(('*'={.port)*.0~:#su)#'superuser and non-localhost has security implications!'
t=. jcs_start_template rplc 'PORT';":port
t=. t rplc 'SU';su
admin=. (-LF={:admin)}.admin
t=. t rplc 'ADMIN';admin
t fwrite file
i.0 0
)

NB. start'~temp/sa.ijs'
jcs_start=: 3 : 0
t=. jpath'~temp/jcs_start.txt'
if. FHS*.IFUNIX do.
fork_jtask_ 'ijconsole "',y,'" > "',t,'"'
else.
fork_jtask_ '"',(jpath'~bin/jconsole'),'" "',y,'" > "',t,'"'
end.
6!:3[0.5 NB. kludge to let task get started
fread t
)
