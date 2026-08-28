NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. manage jd server

coclass'jd'
jdserver_z_=: jdserver_jd_

man_jd_c_server_overview=: 0 : 0
server - node task running a proxy and a J task running a zmq loop

node - https://nodejs.org
 jd.js - serves https requests - reverse proxy to Jd
 handles logon user/pswd
 Jd ops passed to J task with localhost zmq

J task handles zmq requests from node task
 jdserverinit - connects to zmq and calls jdserverrun
 jdserverrun - loops on zmq for requests and returns results
 jds - run op and returns result

https clients (ibcurl/curl/browser)
)

man_jd_d_server_client=: 0 : 0
libcurl/curl/browser - post https request to node task

post data: jdcmd LF nodecmd

jdcmd is encoding of the same cmd that would be used in a direct request
jdcmd is encoded as either jbin (3!:1) or json
the string is usually (optionally) lz4 comressed

nodecmd is 0 or more commands seprated by ;
 logon dan user pswd - validate and add valid user to user table
 logoff - remove user from user table at end
 free   - logoff, free curl and other resources at end
 port n - route op to this port
 eok    - Jd error result does not sigmal error

nodecmd of op ... added automatically with op from jdcmd
op used to route server requests to different ports
write ops to base port and read ops to clones

post request (with op command added):
(lz4 3!:1 'insert t';'a';45),LF,'eok;op insert'
((lz4 '["insert t","a",45]'),LF,'op insert;'

   man'jdclient' NB. info on J client requests
)

man_jd_e_server_debug=: 0 : 0
following assumes s1 server and that you are on the server machine

*** jd debug
convert running server to have:
 base jd task restarted in jconsole
 node task restarted (if necessary) to run with inspect-yes

start jconsole
   load'jd' NB. or production as appropriate
   load JDP,'test/util/simple.ijs'
   s1_run''
   jdserver's1 debug' NB. restart tasks
   
ctrl+c - interrupt server zmq loop
   RELOAD NB. jds main file
edit RELOAD - e.g. add (decho jdsq__=: y) at start jds defn   
   load 'jd' 
   jdserverrun'' NB. resume zmq loop

*** node debug
start host terminal   
 $ node inspect localhost:3001 # 1 + node port
 debug> help
 debug> sb('jd.js',35)
)

NODE_TIME_jd_=: 10000 5000 20000 50

NB. manage servers
NB. * 'name op'
NB. * 'name op';arg
NB. * 'name';'op' [;arg]
NB. name    - jdscpath/server/name - jd server folder
NB. op      - create/start/...
NB.   man'jdscreate'             NB. more info (jdsstop and others)
NB.   jdserver 'name create';... NB. create server folders
NB.   jdserver 'name delete'     NB. kill tasks and delete server-folder
NB.   jdserver 'name start'      NB. start server - ports must not be in use
NB.   jdserver 'name stop [10]'  NB. graceful shutdown
NB.   jdserver 'name status'     NB. status
NB.   jdserver 'name report f c' NB. f is base,clone...,node and c is record count
NB.   jdserver 'name kill'       NB. kill tasks on server ports
NB.   jdserver 'name ports'      NB. ports used by this server
NB.   jdserver 'name pids'       NB. pids on the server ports
NB.   jdserver 'name handle'     NB. return server-folder
NB.   jdserver 'name debug'      NB. restart node as inspect if necessary and jd base in jconsole
jdserver=: 3 : 0
if. 0=L.y do. y=. bdnames y else. y=. (bdnames ;{.y),}.y end.
'name op'=. 2{.y
y=. 2}.y
vdname name
select. op
case. 'create' do. jdscreate name;y
case. 'delete' do. jdsdelete name
case. 'start'  do. jdsstart name
case. 'stop'   do. jdsstop name;y
case. 'kill'   do. jdskill name
case. 'pids'   do. jdspids name
case. 'ports'  do. jdsports name
case. 'status' do. jdsstatus name
case. 'report' do. jdsreport name;y
case. 'handle' do. gethandle name 
case. 'debug'  do. jdsdebug name
case.          do. (op,': invalid jdserver command')assert 0
end.
)

NB. get server-folder from name - check
gethandle=: 3 : 0
h=. gethandlex y
'server-folder does not exist'assert 2=ftype h
h
)

NB. get server-folder from name - no check
gethandlex=: 3 : 0
jdscpath,'server/',(dltb y),'/'
)

NB. restart node as rundebug if inspect task not running
NB. restart jd base task in jconsole
jdsdebug=: 3 : 0
'must run in jconsole'assert -.IFQT+.IFJHS
handle=. jdserver y,' handle'
base=. handle,'base/'
jport=. _1".fread base,'jport'
'this pid is already base pid'assert(2!:6'')~:getpid_jport_ jport
node=. handle,'node/'
nport=. _1".fread node,'a_nport'
if. _1~:getpid_jport_ >:nport do.
 decho 'restart node'
 killport_jport_ 0 1+nport
 jdfork fread node,'rundebug.txt'
'node server failed to start'assert _1~:getpidx_jport_ nport
end. 
killport_jport_  jport
load__ base,'run.ijs'
)

NB.    jdserver 'name create';... NB, create server folders
NB. * jport;db;nport;up;inspect;time
NB. jport   - jd zmq port that serves node server
NB. db      - db to serve
NB. nport   - node port that serves client requests
NB. up      - up or testup - which user/pswd file to use
NB. inspect - inspect-yes or inspect-no - enable node inspect
NB. time    - NODE_TIME_jd_
NB.           interval   - setinterval to check q timeout
NB.           qtimeout   - q time before timeout
NB.           unused
NB.           reptrigger - write ops to trigger repupdate
jdscreate=: 3 : 0
'create requires 7 args'assert 7=#y
'name jport db nport up inspect time'=: y
handle=. jdscpath,'server/',(dltb name),'/' NB. server-folder from name
'handle (server-folder) already exists'assert 0=ftype handle
jport=. ":jport
'invalid jport' assert 1024 65535 inrange 0".jport
'invalid db'assert 'database'-:fread '/jdclass',~adminp db
nport=. ":nport
'invalid nport' assert 1024 65535 inrange 0".jport

'invalid up'assert(<up)e.'up';'testup'
'invalid inspect'assert(<inspect)e.'inspect-yes';'inspect-no'

check_node''
check_zmq''
check_lz4''

mkdir_j_ handle
'jdserver' fwrite handle,'jdclass'
setstatus handle;'created'

NB. create jd server base task config and clone configs

mkdir_j_ handle,'base'
base=. handle,'base/'

create_jds  base;jport;db

clones=. getclones db
for_i. i.#clones do.
 h=. handle,'/',~'clone_',":i
 mkdir_j_ h
 create_jds h;(i+1+0".jport);;i{clones
end.

NB. create node task config
node=. handle,'node/'
mkdir_j_ node
setstatus node;'created'
''fwrite node,'std.log'
''fwrite node,'node.log'
(":nport)fwrite node,'a_nport'
t=. 0".jport
(":t,t+>:i.#clones)fwrite node,'a_jports'
(jdscpath,'up/',((up-:'testup')#'test_'),'upfile') fwrite node,'a_upfilepath'
(":time)fwrite node,'a_time'
JDP fwrite node,'a_jdp'
create_node node;nport;inspect
i.0 0
)

jdsdelete=: 3 : 0
h=. gethandlex y
if. 2=ftype h do.
 'one or more tasks are running'assert 0=#_1-.~jdspids y
jddeletefolder h
end. 
i.0 0
)

jdskill=: 3 : 0
killport_jport_ jdserver y,' ports'
)

jdsports=: 3 : 0
handle=. gethandle y
0".(fread handle,'node/a_nport'),' ',fread handle,'node/a_jports'
)

jdspids=: 3 : 0
getpid_jport_ jdserver y,' ','ports'
)

jdsstatus=: 3 : 0
handle=. gethandle y

r=. y;'';'';'';fread handle,'status'
t=. handle,'base/'
p=. fread t,'jport'
r=. r,'base';p;(":getpid_jport_ 0".p);(fread t,'db');fread t,'status'

NB. get clone info
clones=. getclones fread t,'db'
for_i. i.#clones do.
 n=. 'clone_',(":i)
 t=. handle,n,'/'
 p=. fread t,'jport'
 r=. r,n;p;(":getpid_jport_ 0".p);(fread t,'db');fread t,'status'
end.

t=. handle,'node/'
p=. fread t,'a_nport'
u=. fread t,'a_upfilepath'
u=. (>:u i:'/')}.u
r=. r,'node';p;(":getpid_jport_ 0".p);u;fread t,'status'
seebox (((#r)%5),5)$r
)

NB. start server tasks - base,clones,node
NB. validate that base and clones have same summary and schema
jdsstart=: 3 : 0
handle=. gethandle y
'one or more tasks are running'assert 0=#_1-.~jdspids y

NB. validate db and clones before starting server
jdadmin 0
db=. fread handle,'base/db'
jdadmin db
sum=. jd'info summary'
sch=.  jd'info schema'
clones=. getclones db
for_n. clones do.
jdadmin 0
 n=. ;n
 jdadmin n
 (n,' bad summary or schema')assert (sum-:jd'info summary')*.sch-:jd'info schema' NB. jd'...' does repupdate
end. 
jdadmin 0

start handle,'base/'

clones=. getclones db
for_i. i.#clones do.
  start handle,'/',~'clone_',":i
end.

node=. handle,'node/'
setstatus node;'start'
''fwrite node,'std.log'
''fwrite node,'node.log'
nport=: 0".fread node,'a_nport'
jdfork fread node,'run.txt'
'node server failed to start'assert _1~:getpidx_jport_ nport
i.0 0
)

stopsub=: 3 : 0
jdserver name,' kill' 
('stop jd exit',LF)fappend 'node/std.log',~jdserver's1 handle'
i.0 0
)

NB.    jdserver 'name stop [seconds]' NB. graceful shutdown
NB. return if no tasks are running
NB. return after killing jd task(s) if node.log shows node task has exited
NB. signals sigterm to node task to request orderly shutdown
NB. getpid nport returns _1 after signal sigterm (even if still running)
NB. new requests get 'server stopped' or connection failure
NB. queued requests get 'server stopped'
NB. running jd task(s) continue and return results
NB. jd tasks are killed if node.log indicates node task has exited
NB. error signaled if node has not exited before timeout
NB. jdsstop can be run again to see if node task has exited 
jdsstop=: 3 : 0
'name time'=. y
time=. 1".":;(0=#time){time;10
p=. jdserver name,' pids'
if. *./_1=p do. i.0 0 return. end. NB. return if no pids

NB. request shutdown on http localhost port
admin=. ":2+0".fread  (jdserver (name,' handle')),'node/a_nport'
httpgetr_jpacman_'http://127.0.0.1:',admin,'/shutdown' NB. no error check

for. i.time do.
 6!:3[1
 d=. <;._2 fread   'node/std.log',~jdserver's1 handle'
 if. 'stop node exit'-:;{:d do.
  if. (;_2{d)-:'stop status: 1',;(>:#getclones db)#<' 1' do. stopsub'' return. end.
  'stop - error in shutdown node.log stop status'assert 0
 end.
end. 
'stop timeout - server has not finished shutdown'assert 0
)

jdsreport=: 3 : 0
'name f c'=: y
c=. 0".":c
h=. gethandle name
(f,' folder does not exist')assert 2=ftype h,f
h=. h,f,'/'
if. 'node'-:f do.
 r=. 'std.log:',LF,rdrep h,'std.log'
 r=. r,LF,'node.log:',LF
 d=. <;._2 fread h,'node.log'
 if. 0=#d do. r return. end.
 a=. (>:;d i.each TAB)}.each d
 a=. /:~(a i.each TAB){.each a
 r=. r,2 seebox ('all';~.a),:":each<"0 (#a),+/"1 =a
 r=. r,2 seebox ><;._1 each TAB,each (-c<.#d){.d
else.
 r=. 'std.log:',LF,rdrep h,'std.log'
 r=. r,'jds.log:',LF,jdslog_format h;10
end.
)

get_state_val=: {{;{:(({."1 y) i. <x){y}}

getclones=: 3 : 0
state=. jdgstate_jd_ y
if. 1~:'REPLICATE'get_state_val state do. '' return. end.
'CLONES'get_state_val state
)

start=: 3 : 0
handle=. y
jport=. 0".fread handle,'jport'
db=. fread handle,'db'
if. _1~:getpid_jport_ jport do. 6!:3[0.5 end. NB. time for port to be killed
'port is in use'assert _1=getpid_jport_ jport
setstatus handle;'start'
ferase handle,'jds.log'
jdfork fread handle,'run.txt'
'jd server failed to start'assert _1~:getpidx_jport_ jport
)

debug=: 3 : 0
handle=. y
jport=. 0".fread handle,'jport'
db=. fread handle,'db'
'must run in jconsole'assert -.IFQT+.IFJHS
NB. if we are jport - close the port so we don't kill ourself
setstatus handle;'debug'
load__ handle,'run.ijs' NB. load in base and run zmq loop
)

jdslog_format=: 3 : 0
'handle count'=. y
d=. rdrep handle,'jds.log'
2 seebox ><;._1 each TAB,each (-count<.+/LF=d){.<;._2 d
)

rdrep=: 3 : 0
d=. fread y
;(_1-:d){d;'',LF
)

NB. * handle;status
setstatus=: 3 : 0
'handle status'=: y
((9{.status,':'),isotimestamp 6!:0'') fwrite handle,'status'
)

NB. not used - kill libcurl connection
killlibcurl=: 3 : 0
for_c. conl 1 do.
 if. 0=nc<'jdclass__c'do.
  if. jdclass__c-:'client' do.
   if. y=0".(>:url__c i: ':')}.url__c do. 
    destroy__c''
   end. 
  end.  
 end.
end.
)


NB. create jds server folder

jds_server_config_template=: 0 : 0
JDP_z_=: '<JDP>'
load JDP,'jd.ijs'
IFJDS_z_=: 1
RELOAD=: JDP,'api/api.ijs' NB. likely debug file
load RELOAD
JDSPATH_z_=:    '<PATH>'
UPFILE_jd_=: fread '<PATH>upfilepath'
ductable_jd_=: 0 3$'' NB. each row has dan user cookie
PORT=: <PORT>
DBS=: jdremq_jd_ each ',' strsplit_jd_'<DBS>'
jdserverinit''
)

NB. path;jport;'test,"foo,bar",~temp/jd/mum'
create_jds=: 3 : 0
'path port dbs'=. y
setstatus path;'created'
sport=. ":port
sport fwrite path,'jport'
dbs fwrite path,'db'

f=. jpath path
mkdir_j_ f
log=. f,'log.log'
logstd=. f,'std.log' NB. stdout/stderr
loglevel=. 0

t=. jds_server_config_template rplc '<PORT>';sport;'<DBS>';dbs;'<PATH>';path;'<JDP>';JDP
t fwrite f,'run.ijs'

select. UNAME
case. 'Linux';'FreeBSD';'OpenBSD';'Darwin' do.
 t=. '#!/bin/bash',LF
 t=. t,'"BINPATH/jconsole" "SCRIPT"' rplc 'BINPATH';(jpath'~bin');'SCRIPT';f,'run.ijs'
 if. FHS do. t=. t rplc 'jconsole';'ijconsole' end.
 t fwrite f,'/run.sh'
 shell'chmod +x ',f,'run.sh'
 cmd=. (SETSID,' "PATHrun.sh" > "LOG" 2>&1 &') rplc 'PATH';f;'LOG';logstd
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

NB. create node server folder
NB. PATH;nport;jport
NB. create node files in folder PATH/PORT
create_node=: 3 : 0
'path nport inspect'=. y
nodebin=. 'node'
NB. p=. jpath path,('/'#~'/'~:{:path),'node/'
NB. mkdir_j_ p
p=. jpath path
nodefile=. JDP,'/server/node/jd.js'
curl=. (fread path,'node/curl')rplc'"';'\\\"';'/';'\/';'$';'\$' NB. has to get past shell rules
config=. '{\"handle\":\"<HANDLE>\"}'rplc '<HANDLE>';p
nodeflags=. ' <INSPECT> ' 

yes=. ' --inspect=localhost:',":1+0".":nport
default=. ;(inspect-:'inspect-yes'){'';' --inspect=localhost:',":1+0".":nport

 run=. '"NODEBIN" "INSPECT" "JS" "CONFIG"'
 if. IFWIN do.
 NB. create run.bat and run.txt
 t=. run rplc 'NODEBIN';nodebin;'JS';nodefile;'CONFIG';config
 f=. p,'run.bat'
 t fwrite f
 pw=. hostpathsep p
 ('"PATHrun.bat" > "LOG" 2>&1' rplc 'PATH';pw;'LOG';pw,'std.log') fwrite p,'run.txt'

 a=. fread f
 b=. a rplc '"INSPECT"';default
 b fwrite f
 
 b=. a rplc '"INSPECT"';yes
 b  fwrite p,'rundebug.bat'

 a=. fread p,'run.txt'
 b=. a rplc 'run.bat';'rundebug.bat'
 b fwrite p,'rundebug.txt'

else.

 NB. create run.sh rundebug.sh run.txt rundebug.txt
 t=. '#!/bin/bash',LF
 t=. t, run rplc 'NODEBIN';nodebin;'JS';nodefile;'CONFIG';config
 f=. p,'run.sh'
 r=. t fwrite f
 shell'chmod +x "',f,'"'
 (SETSID,' "PATHrun.sh" > "LOG" 2>&1' rplc 'PATH';p;'LOG';p,'std.log') fwrite p,'run.txt'

 a=. fread p,'run.sh'
 b=. a rplc '"INSPECT"';default
 b  fwrite p,'run.sh'
 b=. a rplc '"INSPECT"';yes
 f=. p,'rundebug.sh'
 b  fwrite f
 shell'chmod +x "',f,'"'

 a=. fread p,'run.txt'
 b=. a rplc 'run.sh';'rundebug.sh'
 b fwrite p,'rundebug.txt'
 
end. 

(fread JDP,'server/node/server.html') fwrite p,'/server.html' NB.! ???
i.0 0
)

NB. * 'host:port'
NB. create curl client files
NB. returns path to curl client files
NB. used by jd client that use curl intead of libcurl
jdcurlclient=: 3 : 0
'host port'=. <;._1 ':',y
cert=. ('localhost'-:host){'';'-k' NB. localhost curl option -k
path=. jdscpath,'curl/',host,'-',port
mkdir_j_ path
a=. fread JDP,'server/client/curl'
a=. a rplc '$1';path;'$2';(host,':',port);'$3';cert
a fwrite path,'/curl'
'client'fwrite path,'/jdclass'
path
)

NB. * '' NB. report requirements not met
NB. Jd server has requirements in addition to the base J install
NB. 
NB. steps to meet these requirements are beyond the scope of this document
NB. they are well documented on the web and hopefully not too difficult
NB. following hints might help
NB.
NB. *** zmq:
NB.  follow advice at zeromg.org and on net
NB.  linux: $ sudo apt-get install libzmq3-dev
NB.  mac:   $ brew install zmq
NB.  windows: vcpkg?
NB. 
NB. *** lz4:
NB.  windows/mac: lz4 addon includes lz4 binary
NB.  linux: $ sudo apt install lz4
NB.
NB. *** libcurl
NB.  follow advice at https://curl.se/libcurl/ and on net
NB.  linux: $ sudo apt install libcurl
NB.  mac:   $ brew install libcurl
NB.  windows:
NB.   download windows libcurl from curl.se/windows
NB.   unzip and copy bin folder to c:\Program Files\curl
NB.   mklink libcurl.dll "c:\Program Files\curl\bin\libcurl-x64.dll
NB. 
NB. *** node (nodejs.org) hints:
NB.  follow advice at node.org and on net
NB.  you need to install node and npm (node package manager)
NB.  when node is installed you also have to install additional modules
NB.  $ npm install zeromq
NB.  $ npm install async-mutex
NB.
NB. *** certs
NB.  node requires cert.pem and fullchain.pem files in .ssh/jserver
NB.  for testing/development you can install self-signed certificates
NB.   install_self_signed_certs_jd_''
NB.
NB. *** setsid
NB. mac is missing setsid utility so Mac univeral setsid is included in JDP,'cd/setsid.
check_all=: 3 : 0
check_zmq''
check_lz4''
check_libcurl''
check_node''
check_certs''
)

NB. node --version must have suitable version
check_node=: 3 : 0
r=. shell :: _1: 'node --version'
'check_node failed - node is not installed'assert -._1-:r
'check_node failed - node --version is too old'assert 18<:{.0".(}.r)rplc'.';' '
'check_node failed - node zeromq not installed'assert 0=#shell :: _1: 'node -e "require(''zeromq'')"'
'check_node failed - node async-mutex not installed'assert 0=# shell'node -e "require(''async-mutex'')"'
)

check_zmq=: 3 : 0
try. version_jcs_''
catch.
'check_zmq failed - zmq shared library not found'assert 0
end.
'check_zmq failed - must be version 4.1.4 or later'assert 414<:10#.version_jcs_''
)

check_lz4=: 3 : 0
if. IFWIN+.UNAME-:'Darwin' do. return. end. NB. win and mac addons has binary
t=. '*** LZ4 command line interface 64-bits '
'check_lz4 failed - lz4 not installed'assert t-:($t){.shell :: _1: 'lz4 --version'
)

check_libcurl=: 3 : 0
'check_libcurl failed - libcurl not installed'assert 0=curl_global_init_jcurl_ :: 1: CURL_GLOBAL_ALL_jcurl_
)

check_certs=: 3 : 0
'check_certs failed - .ssh/jserver/key.pem does not exists'       assert 1=ftype '.ssh/jserver/key.pem'
'check_certs failed - .ssh/jserver/fullchain.pem does not exists' assert 1=ftype '.ssh/jserver/fullchain.pem'
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
