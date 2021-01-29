NB. how to run a Jd server task with jds

require JDP,'server/jds/jds_tools.ijs'

PORT=:    65220
LOGLEVEL=: 0 NB. 0 for all, 1 for only important
DBS=: 'jds_db_a,jds_db_b' NB. list of dbs to jdadmin - "s around as required
NB. server init does jdadmin for each db - 'new'jdadmin if db does not exist

spath=: '~temp/jdserver' NB. path to server folders
NB. next step creates scripts for managing the jds server on PORT
[path=: create_jds spath;PORT;LOGLEVEL;DBS
run_sh_bat=: ;('Win'-:UNAME){'run.sh';'run.bat'
dir path
fread path,'run.ijs'  NB. ijs script to start this server
fread path,run_sh_bat NB. host shell script to run this server
fread path,'run.txt'  NB. fork_jtask_ arg to start this server

killport PORT NB. kill task (if any) serving port
fork_jtask_ fread path,'run.txt' NB. start jds server on port 
i.0 0[6!:3[0.2 NB. give task a chance to get started
pidfromport PORT NB. pid of server task - _1 if start failed
fread path,'logstd.log' NB. stdout/stderr log
fread path,'log.log'    NB. event log
killport PORT NB. kill the server

NB. setup 65221 server for use by node tutorial
create_jds spath;65221;LOGLEVEL;'jds_db_c,jds_db_d'

0 : 0
   jdrt'jds_client' NB. how a client can use a server
   jdrt'node'       NB. how to set up a node server to access a server
)   
