NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. manage node-jd-DB server

coclass'jdserver'
coinsert'jd'

man_jd_server=: 0 : 0
   sj=: 'jdserver/abc' conew 'jdserver' NB. locale with server manager tools
   
   NB. node-port ; jds-port ; dbs
   NB. dbs - 0 or more dbs - admin user can open/close dbs on running server 
   NB. node inspect at localhost:nport+1
   config__sj 3000;65220;dbs
   
   run__sj 1 NB. start server - 0 forks and 1 spawns visible jconsole jds for debugging

   nodelog__sj'' NB. node stdout/stderr log
   jdslog__sj''  NB. jds log

   report__sj'' NB. report server config and status
   
   kill__sj''   NB. kill node/jds tasks
   delete__sj'' NB. delete server config folder

example use in : ~addons/data/jd/server/simple_server.ijs
)

man_jd_server_debug=: 0 : 0
*** debug jds
if run arg was 0, then kill that task and restart with 1
   kill__sl ''
   run__sl 1

ctrl+c
   RELOAD NB. jds main file
edit RELOAD file - e.g. add decho y line at start jds defn   
   load RELOAD
   run''

*** debug node
$ node inspect host:node-port+1
debug> help
debug> sb('reverse_proxy_binary.sj',35)
)

man_jd_server_overview=: 0 : 0
structure of node server <> jd server

... https clients ...
  node server       
  reverse_proxy_binary.js
  proxy for jds in jd server

  jd server
  ZMQ
  (zmq requests added to job queue with route info)
  (result returned with zmq route info)
  jcs.ijs
  jds - server/client.ijs
  jds loops running jobs from queue and returning results

***
nodeserver and jdserver could be started/stopped independently
 but for now we assume it is is all up or all down

nodeserver could serve multiple jdservers (even on other hosts)
 but for now it is one node server for one jd server
)

NB. 'jdserver/test' conew 'jdserver'
create=: 3 : 0
path=. y,('/'~:{:y)#'/' NB. trainling /
b=. (>:'/'i:~}:path){.path
t=. '/'-.~(('/',}:b)i:'/')}.b
'folder before last folder must be jdserver'assert t-:'jdserver'
'mkdir failed'assert 1=mkdir_j_ path
server=: path
upfile=: path,'upfile'
if. -.fexist upfile do. ''fwrite upfile end.
'server' fwrite path,'jdclass'
i.0 0
)

destroy=: codestroy

NB. set jport etc from server
setup=: 3 : 0
path=. server
'path to server files is invalid' assert 2=ftype path
'path to server files is empty' assert 0~:dirtree path
pfj=. path,'jds/'
jport=. 0".fread pfj,'jport'
pfn=. path,'node/'
nport=. 0".fread pfn,'nport'
jport;nport;pfj;pfn
)

NB. * 3000;65220;'simple'
NB. node-port ; jds-port ; 1 or more databases
NB. configure server
config=: 3 : 0
check_nodebinpath''
'nport jport dbs'=. y
path=. server
'server path already configured - delete required' assert 2~:ftype path,'jds'
mkdir_j_ path
mkdir_j_ path,'jds'
mkdir_j_ path,'node'
(5!:5<'y')fwrite path,'config'
'server' fwrite path,'jdclass'
nport=. ":nport
jport=. ":jport
jport fwrite path,'jds/jport'
nport fwrite path,'node/nport'
create_jds  path;jport;dbs
create_node path;nport;jport
i.0 0
)

adduser=: 3 : 0
uj=: server conew'jdup'
adduser__uj 'admin/funny'
adduser__uj'user0/user0'
)

rep=: 3 : 0
echo '   ',y
echo ".y
)

NB. server_path
report=: 3 : 0
echo 'config: ',fread server,'config'
echo ' '
echo '   nodelog__sj'''''
echo '   jdslog__sj'''''
echo ' '
rep  'pidport_jport_'''''
)

nodelog=: 3 : 0
'jport nport pfj pfn'=. setup''
fread pfn,'logstd.log'
)

jdslog=: 3 : 0
'jport nport pfj pfn'=. setup''
fread pfj,'logfile.log'
)

NB. delete server folder
delete=: 3 : 0
jddeletefolder server
i.0 0
)

NB. kill server tasks/ports
kill=: 3 : 0
'jport nport pfj pfn'=. setup''
killport_jport_ jport
killport_jport_ nport
i.0 0
)

NB. 0 or 1 for debug with visible spawned jds task
run=: 3 : 0
dbg=. y
path=. server
'jport nport pfj pfn'=. setup''
'.ssh/jserver/cert.pem does not exist' assert 1=ftype '.ssh/jserver/cert.pem'
'.ssh/jserver/fullchain.pem does not exist' assert 1=ftype '.ssh/jserver/fullchain.pem'
'upfile does not exist - newupfile'  assert 1=ftype upfile
'upfile has no users - adduser'     assert 0<fsize upfile
'zmq must be version 4.1.4 or later'assert 414<:10#.version_jcs_''
'server ports in use - kill required' assert _1=;pidfromport_jport_ each jport,nport

ferase pfj,'logfile.log' NB. remove old jds log file

if. dbg do.
 spawn_jtask_'x-terminal-emulator -e "\"j9.6/bin/jconsole\" \"',(jpath path,'jds/run.ijs'),'\" "'
else.
 fork_jtask_ fread pfj,'run.txt'
end.
fork_jtask_ fread pfn,'run.txt'

6!:3[0.2 NB. time to spin up

NB. dbg jds spawn won't finish until ???
if. -.dbg do. 'jd server failed to start'   assert _1~:pidfromport_jport_ jport end.

'node server failed to start' assert _1~:pidfromport_jport_ nport
i.0 0
)

check_nodebinpath=: 3 : 0
fn=. '~config/nodebinpath'
if. 1=ftype f) do. if. 1= ftype fread fn do. return. end. end.
if. IFWIN do. if. 1~: ftype fp=. 'c:\Program Files\nodejs\node.exe' do. fp=. _1 end.
else. if. _1 -.@-: fp=. 2!:0 ::_1: 'which node' do. fp=. fp-.LF end.
end.
if. _1 -.@-: fp do. (jpath fp) fwrite fn
else.
r=. 'you need to run following sentence to set the path to node binary',LF
r=. r,'   (jpath''path to node binary'') fwrite ',fn
echo r
'manual step required'assert 0
end.
i.0 0
)
