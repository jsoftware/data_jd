NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. manage node-jd-DB server

coclass'jdserver'
coinsert'jd'

jdserver_z_=: jdserver_jdserver_

man_jd_server_1_requirements=: 0 : 0
Jd server uses zmq (zeromq), node (node.js), lz4 (compression), and libcurl

check status with:
   check_zmq_jdserver_''
   check_node_jdserver_''
   check_lz4_jdserver_''
   check_libcurl_jdserver_''

how to install zmq, node, lz4, and libcurl is beyond the scope of this document
they are common tools and the hopefully the install is not too difficult

windows libcurl install hints:
1. download windows libcurl from curl.se/windows
2. unzip and copy bin folder to c:\Program Files\curl
3. mklink libcurl.dll "c:\Program Files\curl\bin\libcurl-x64.dll

Mac is missing setsid utility so Mac univeral setsid is included in JDP,'cd/setsid.
)

man_jd_server_2_debug=: 0 : 0
Following assumes server1.ijs (adjust as necessary) and that you are on the sever machine.

*** basic info
   load'gitjd'
   jdserver 'server-name';'report'

 *** debug j  - running in a visible jconsole task can be useful
   killport_jport_ 65220 NB. kill jd server task

start jconsole
   load jdscpath,'server/server1/jds/run.ijs'

ctrl+c - interrupt server zmq loop
   RELOAD NB. jds main file
edit RELOAD - e.g. add (decho jdsq__=: y) line at start jds defn   
   load 'jd' 
   run '' NB. resume zmq loop

*** debug node
   jdserver 'create';'server1';3000;'simple';'testup';'inspect-yes' NB. inspect enabled
   jdserver'run' 

start host terminal   
 $ node inspect localhost:3001 # 1 + node port
 debug> help
 debug> sb('reverse_proxy_binary.js',35)
)

man_jd_server_0_overview=: 0 : 0
server - J task with Jd running a zmq loop and a node task running a proxy

node task serves client requests
 node handles https and is a reverse proxy to Jd
 https://nodejs.org

jds (Jd server) task handles http requests from node task
 jds uses zmq for localhost connections from node task

https clients (browser/libcurl/curl)
  node task
    reverse_proxy_binary.js
    requests passed to J task and reponse returned to client
  j task running Jd server
    zmq loop
    zmq requests added to jds job queue
    jd runs request from job queue
    jd result added to zmq result gueue
    zmq returns response to node task
)

NB. * name;op;...
NB. name    - jdscpath,name is server handle
NB. jport   - jds zmq port that serves node reverse-proxy
NB. nport   - node port that serves client requests
NB. dbs     - 0 or more db names separated by ,
NB.           db can be name (~temp/jd/name) or path '..../name'
NB. up      - up or testup - which user/pswd file to use
NB. inspect - inspect-yes or inspect-no - enable node inspect
NB.
NB.    jdserver name;'create';jport;nport;dbs;up;inspect NB. create server-folder
NB.    jdserver name;'start'      NB. start server - kills existing task on jport and nport
NB.    jdserver name;'report'     NB. detailed report
NB.    jdserver name;'stop'       NB. stops server
NB.    jdserver name;'debug'      NB. start - jds in visible jconsole and node --inspect
NB.    jdserver name;'handle'     NB. return server-folder
NB.    jdserver name;'delete'     NB. kill tasks and delete server-folder
NB.    jdserver ''  ;'report'     NB. status for all servers
jdserver=: 3 : 0
'arg must be server-name;op[;...]'assert 2<:#y
'name op'=. 2{.y
y=. 2}.y
op=. dltb op
handle=. jdscpath,'server/',(dltb name),'/' NB. server-folder from name
if. (''-:name)*.op-:'report' do. names handle return. end.
if. (op-:'delete')*.0=ftype handle do. i.0 0 return. end.
if. op-:'create' do.
 'handle (server-folder) already exists'assert 0=ftype handle
 create handle;y
 return.
end.
'not a server-folder' assert 'server'-:fread handle,'jdclass'
'jport nport'=. setup handle
select. op
case. 'handle' do. handle return.
case. 'start'  do. start handle return.
case. 'debug'  do. debug handle return.
case. 'stop'   do.
 ('stopped: ',isotimestamp 6!:0'') fwrite handle,'status'
 clearports jport,nport
case. 'delete' do.
 clearports jport,nport
 rmdir_j_ }:handle
case. 'report' do. report handle return.
case.          do. 'invalid op' assert 0
end.
i.0 0
)

clearports=: 3 : 0
'jport nport'=. y
 killlibcurl'' NB.kill libcurl connections
 killport_jport_ jport
 killport_jport_ nport
)

names=: 3 : 0
t=. jdscpath_jd_,'server'
d=. (>:#t)}.each {."1 dirtree t
d=. /:~~.(d i.each '/'){.each d
d,.fread each (<t),each '/',each d,/each<'/status'
)

NB. * name;jport;port;dbs;up;inspect
NB. multiple dbs separated by ,
NB. up is up or testtup (upfilepath)
NB. inspect is inspect-yes or inspect no - node inspect
NB. create jdserver-folder
NB. tasks for jport and nport are killed
create=: 3 : 0
'create requires 6 args'assert 6=#y
'handle jport nport dbs up inspect'=. y
nport=. 0".":nport
jport=. 0".":jport
'invalid node port' assert (nport>:1024)*.nport<:65535
'invalid jds port' assert (nport>:1024)*.jport<:65535
dbs=. }.;',',each~.deb each ','splitstring dbs
'invalid dbs'assert -.RESERVEDCHARS e. dbs-.','
'invalid up'assert(<up)e.'up';'testup'
'invalid inspect'assert(<inspect)e.'inspect-yes';'inspect-no'

check_node''
check_zmq''
check_lz4''

mkdir_j_ handle
'server' fwrite handle,'jdclass'
(5!:5<'y')fwrite handle,'config'
mkdir_j_ handle,'jds'
mkdir_j_ handle,'node'
cleanstatus handle;'created'
cjport=: ":jport
cnport=: ":nport
cjport fwrite handle,'jds/jport'
cnport fwrite handle,'node/nport'
create_jds  handle;cjport;dbs
create_node handle;cnport;cjport;inspect
(jdscpath,'up/',((up-:'testup')#'test_'),'upfile') fwrite handle,'upfilepath'
i.0 0
)

setup=: 3 : 0
(0".fread y,'jds/jport'),0".fread y,'node/nport'
)

jdslog_format=: 3 : 0
'handle count'=. y
d=. rdrep handle,'jds.log'
2 seebox ><;._1 each TAB,each (-count<.+/LF=d){.<;._2 d
)

rdrep=: 3 : 0
d=. fread y
;(_1-:d){d;'does not exist',LF
)

NB. server summary report
report=: 3 : 0
r=. fread y,'config'
r=. r,LF,fread y,'status'
r=. r,LF,LF,'jds.log:',LF,jdslog_format y;10
r=. r,LF,'jds/logstd.log:',LF,rdrep y,'jds/logstd.log'
r=. r,LF,'node/logstd.log:',LF,rdrep y,'node/logstd.log'
)

certerror=: 0 : 0
node https server requires cert.pem and fullchain.pem files in .ssh/jserver
for testing/development you can install self-signed certificates
   install_self_signed_certs_jdserver_''
)

NB. handle;status
cleanstatus=: 3 : 0
'handle status'=: y
(status,': ',isotimestamp 6!:0'') fwrite handle,'status'
ferase handle,'jds.log'
ferase handle,'jds/logstd.log'
ferase handle,'node/logstd.log'
)

NB. end libcurl connection before we can kill node
killlibcurl=: 3 : 0
for_c. conl 1 do.
 if. 0=nc<'jdclass__c'do.
  NB. echo 'destroy: ',url__c
  destroy__c''
 end.
end.
)

NB. start jds and node tasks
NB. kills tasks on ports if already running - no error
start=: 3 : 0
handle=. y
'jport nport'=. setup handle
'upfile does not exist'  assert 1=ftype fread handle,'upfilepath'
certerror assert 1=;ftype each '.ssh/jserver/key.pem';'.ssh/jserver/fullchain.pem'

clearports jport,nport

NB. while. 0<getpid_jport_ jport do. 6!:3[0.1[killport_jport_ jport end.
NB. while. 0<getpid_jport_ nport do. 6!:3[0.1[killport_jport_ nport end.

cleanstatus handle;'started'

fork_jtask_ fread handle,'node/run.txt'
fork_jtask_ fread handle,'jds/run.txt'

if. +./_1=a=. ;getpidx_jport_ each jport,nport do.
 NB. jds and/or node task did not start
 m=. 'jds and/or node task failed to start',LF
 if. _1={.a do.
  m=. m,LF,~'jds task did not start on port: ',":jport
  m=. m,LF,~":fread handle,'jds/logstd.log'
 end. 
 if. _1={:a do.
  m=. m,LF,~'node task did not start on port: ',":nport
  m=. m,LF,~":fread handle,'node/logstd.log'
 end.
 m assert 0
end.

'jds server failed to start'  assert _1~:getpidx_jport_ jport NB. delay to let spin up
'node server failed to start' assert _1~:getpidx_jport_ nport
'server started: ',fread handle,'config'
)

debug=: 3 : 0
handle=. y
'must run in jconsole'assert -.IFQT+.IFJHS
'jport nport'=. setup handle
'upfile does not exist'  assert 1=ftype fread handle,'upfilepath'
certerror assert 1=;ftype each '.ssh/jserver/key.pem';'.ssh/jserver/fullchain.pem'

NB. if we are jport - close the port so we don't kill ourself
if. (2!:6'')=getpid_jport_ jport do. destroy__c [ c=. {.{.jcs_jcs_'' end.

while. 0<getpid_jport_ jport do. 6!:3[0.1[killport_jport_ jport end.
while. 0<getpid_jport_ nport do. 6!:3[0.1[killport_jport_ nport end.
cleanstatus handle;'debug'

fork_jtask_ fread handle,'node/rundebug.txt'
load__ handle,'jds/run.ijs' NB. load in base and run zmq loop
)

NB. check ~config/nodebinpath for for valid node binary
NB. set ~confid/nodebinpath if required and verify --version
check_node=: 3 : 0
fn=. '~config/nodebinpath'
if. _1-:fread fn do.  NB. not set - try to set it
 if. IFWIN do. if. 1~: ftype fp=. 'c:\Program Files\nodejs\node.exe' do. fp=. _1 end.
 else. if. _1 -.@-: fp=. 2!:0 ::_1: 'which node' do. fp=. fp-.LF end.
 end.
 if. _1 -.@-: fp do.
  echo'setting ',fn,' to: ',fp
  (jpath fp) fwrite fn
 else.
  m=. 'you need to run following sentence to set the path to node binary',LF
  m=. m,'   (jpath''path to node binary'') fwrite ',fn,LF
  m assert 0
 end.
end.
NB. check that it is set properly
r=. shell :: _1: '"',(fread fn),'" --version'
'~config/nodebinpath is not path to node binary'assert -._1-:r
'~config/nodebinpath has bad --version'assert ('v'={.r)*.18>:{.0".(}.r)rplc'.';' '
i.0 0
)

check_zmq=: 3 : 0
'zmq must be version 4.1.4 or later'assert 414<:10#.version_jcs_''
)

check_lz4=: 3 : 0
'lz4 not installed'assert -._1=shell :: _1: 'lz4 --version'
)

check_libcurl=: 3 : 0
'libcurl not installed'assert 0=curl_global_init_jcurl_ :: 1: CURL_GLOBAL_ALL_jcurl_
)

NB. copy jhs self-signed certs to .ssh/jserver
install_self_signed_certs=: 3 : 0
p=. '.ssh/jserver'
'.ssh stuff failed' assert 1=mkdir_j_ p
'key.pem already exists'       assert 0=ftype p,'/key.pem'
'fullchain.pem already exists' assert 0=ftype p,'/fullchain.pem'
d=. fread'~addons/ide/jhs/node/cert.pem'
d fwrite p,'/fullchain.pem'
d=. fread'~addons/ide/jhs/node/key.pem'
d fwrite p,'/key.pem'
i.0 0
)
