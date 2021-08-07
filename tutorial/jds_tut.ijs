NB. how to run a Jd server task with jds

require JDP,'server/jds/jds_tools.ijs'

spath=: '~temp/jdserver' NB. path to server folders
PORT=:    65220
LOGFILE=: spath,'/jds/',(":PORT),'/log.log'
LOGLEVEL=: 0 NB. 0 for all, 1 for most, ..., 9 for only important
DBS=: 'jds_db_a,jds_db_b' NB. dbs to jdadmin - "s around as required
NB. server init does jdadmin for each db - 'new'jdadmin if db does not exist

NB. next step creates scripts for managing the jds server on PORT
[path=: create_jds spath;PORT;LOGFILE;LOGLEVEL;DBS
run_sh_bat=: ;('Win'-:UNAME){'run.sh';'run.bat'
dir path
fread path,'run.ijs'  NB. ijs script to start this server
fread path,run_sh_bat NB. host shell script to run this server
fread path,'run.txt'  NB. fork_jtask_ arg to start this server

killport_jport_ PORT NB. kill task (if any) serving port
check_jds PORT NB. start jds server on PORT
pidport_jport_'' NB. table of pids and ports
pidfromport_jport_ PORT NB. pid of server task - _1 if start failed
fread path,'logstd.log' NB. stdout/stderr log
fread path,'log.log'    NB. event log
killport_jport_ PORT NB. kill the server

0 :0
you might want to run the jds server in a terminal window
so you see log messages that will help in debugging
to run the jds server in a terminal window:
 
   killport PORT NB. kill currrent server
   path,runit    NB. command to paste into terminal to run server
)   

NB. setup 65221 server for use by node tutorial
create_jds spath;65221;(spath,'/jds/65221/log.log');LOGLEVEL;'jds_db_c,jds_db_d'

0 : 0
   jdrt'jds_client' NB. how a client can use a server
   jdrt'node'       NB. how to set up a node server to access a server
)   
