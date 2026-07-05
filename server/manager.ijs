NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. manage node-jd-DB server

coclass'jdserver'
coinsert'jd'

jdserver_z_=: jdserver_jdserver_
jdnode_z_=: jdnode_jdserver_

man_jd_server_client=: 0 : 0
libcurl/curl/browser/... post https request to node task

post data: jdcmd LF nodecmd

jdcmd is encoding of the same cmd that would be used in a direct request
jdcmd is encoded as either jbin (3!:1) or json
the string is usually (but optionally) lz4 comressed

(lz4 3!:1 'insert t';'a';45)
(lz4 '["insert t","a",45]')

nodecmd is 0 or more commands seprated by ;
 logon dan user pswd - validate and add valid user to user table
 logoff - remove user from user table when request finishes
 port   - route op to this port
 eok    - Jd error result does not signal error
 free   - logoff, free curl and other resources

nodecmd of op ... added automatically with op from jdcmd
op used to route server requests to different ports
write ops to the base port and read ops to clones

example of post request:
(lz4 3!:1 'insert t';'a';45),LF,'eok;op insert'
((lz4 '["insert t","a",45]'),LF,';op insert;'

   man'req' NB. for details on J client requests
)

man_jd_server_requirements=: 0 : 0

!!! node zeromq may be required:
beyond scope of this document
$ sudo apt install npm
$ npm install zeromq # installs in ~/node_modules
$ npm install async-mutex

Jd server uses zmq (zeromq), node (node.js), lz4 (compression), and libcurl

node server requires cert.pem and fullchain.pem files in .ssh/jserver
for testing/development you can install self-signed certificates
   install_self_signed_certs_jdserver_''

check status with:
   check_zmq_jdserver_''
   check_node_jdserver_''
   check_lz4_jdserver_''
   check_libcurl_jdserver_''
   check_certs_jdserver_''

how to install zmq, node, lz4, and libcurl is beyond the scope of this document
they are common tools and the hopefully the install is not too difficult

windows libcurl install hints:
1. download windows libcurl from curl.se/windows
2. unzip and copy bin folder to c:\Program Files\curl
3. mklink libcurl.dll "c:\Program Files\curl\bin\libcurl-x64.dll

Mac is missing setsid utility so Mac univeral setsid is included in JDP,'cd/setsid.
)

man_jd_server_debug=: 0 : 0
following assumes simple server and that you are on the server machine

*** jd debug
start jconsole
   load'jd' NB. or your production Jd as appropriate
   jdserver 'simple';'report'
   jdserver 'simple';'stop'
   jdserver 'simple';'debug' NB. run server in this task
ctrl+c - interrupt server zmq loop
   RELOAD NB. jds main file
edit RELOAD - e.g. add (decho jdsq__=: y) line at start jds defn   
   load 'jd' 
   run '' NB. resume zmq loop

*** node debug
assumes node configured with inspect-yes

start host terminal   
 $ node inspect localhost:3001 # 1 + node port
 debug> help
 debug> sb('jd.js',35)
)

man_jd_server_overview=: 0 : 0
server - J task with Jd running a zmq loop and a node task running a proxy

node task serves client requests
 node handles https and is a reverse proxy to Jd
 https://nodejs.org

jds (Jd server) task handles http requests from node task
 jds uses zmq for localhost connections from node task

https clients (browser/libcurl/curl)
  node task
    jd.js
    requests passed to J task and reponse returned to client
  j task running Jd server
    zmq loop
    zmq requests added to jds job queue
    jd runs request from job queue
    jd result added to zmq result gueue
    zmq returns response to node task
)

NB. * name;op;... - manage jd servers
NB. name    - jdscpath/server/name - jd server handle
NB. op      - create/start/debug/stop/report/status/delete/handle
NB. jport   - jds zmq port that serves node server
NB. db      - db to serve (work would allow 0 or multiple dbs)
NB.
NB.    jdserver name;'create';jport;db NB. create server-folder
NB.    jdserver name;'start'      NB. start server - kills existing task on jport and nport
NB.    jdserver name;'debug'      NB. start - jds in visible jconsole and node --inspect
NB.    jdserver name;'stop'       NB. stops server
NB.    jdserver name;'report'     NB. report
NB.    jdserver name;'status'     NB. status;port;pid - '' for all
NB.    jdserver name;'handle'     NB. return server-folder
NB.    jdserver name;'delete'     NB. kill tasks and delete server-folder
jdserver=: 3 : 0
'arg must be server-name;op[;...]'assert 2<:#y
'name op'=. 2{.y
y=. 2}.y
op=. dltb op
handle=. jdscpath,'server/',(dltb name),'/' NB. server-folder from name
if. op-:'status' do. serverstatus'' return. end.
if. (op-:'delete')*.0=ftype handle do. i.0 0 return. end.
if. op-:'create'                   do. create handle;y return. end.

'not a server-folder' assert 'jdserver'-:fread handle,'jdclass'
select. op
case. 'handle' do. handle return.
case. 'start'  do. start handle return.
case. 'debug'  do. debug handle return.
case. 'stop'   do. stop handle  return.
case. 'delete' do. delete handle return.
case. 'report' do. report handle return.
case.          do. 'invalid op' assert 0
end.
i.0 0
)

get_state_val=: {{;{:(({."1 y) i. <x){y}}

getclones=: 3 : 0
state=. jdgstate_jd_ y
if. 1~:'REPLICATE'get_state_val state do. '' return. end.
'CLONES'get_state_val state
)

NB. * server-handle;jport;db
NB. create jdserver-folders
create=: 3 : 0
'create requires 3 args'assert 3=#y
'handle jport db'=. y
'handle (server-folder) already exists'assert 0=ftype handle
jport=. ":jport
'invalid jport' assert 1024 65535 inrange 0".jport
'invalid db'assert 'database'-:fread '/jdclass',~adminp db

mkdir_j_ handle
'jdserver' fwrite handle,'jdclass'
setstatus handle;'created'

NB. write config info to handle
jport fwrite handle,'jport'
db fwrite handle,'db'

create_jds  handle;jport;db

clones=. getclones db
for_i. i.#clones do.
 clone=. jpath ;i{clones
 name=. (>:clone i:'/')}.clone
 jdserver name;'create';(i+1+0".jport);clone NB. 65220 ???
end.
i.0 0
)

delete=: 3 : 0
'handle'=. y
db=. fread handle,'db'
jport=. 0".fread handle,'jport'
if. (2!:6'')=getpid_jport_ jport do. destroy__c [ c=. {.{.jcs_jcs_'' end.
killport_jport_ jport
rmdir_j_ }:handle

clones=. getclones db
for_i. i.#clones do.
 clone=. jpath ;i{clones
 name=. (>:clone i:'/')}.clone
 jdserver name;'delete'
end.
i.0 0
)

start=: 3 : 0
handle=. y
jport=. 0".fread handle,'jport'
db=. fread handle,'db'
if. _1~:getpid_jport_ jport do. 6!:3[0.5 end. NB. time for port to be killed
'port is in use'assert _1=getpid_jport_ jport
setstatus handle;'start'
ferase handle,'jds.log'
fork_jtask_ fread handle,'run.txt'
'jd server failed to start'assert _1~:getpidx_jport_ jport

clones=. getclones db
for_i. i.#clones do.
 clone=. jpath ;i{clones
 db=. (>:clone i:'/')}.clone
 jdserver db;'start'
end. 
)

stop=:  3 : 0
handle=. y
db=. fread handle,'db'
jport=. 0".fread handle,'jport'
setstatus handle;'stop'
if. (2!:6'')=getpid_jport_ jport do. destroy__c [ c=. {.{.jcs_jcs_'' end.
killport_jport_ jport

clones=. getclones db
for_i. i.#clones do.
 clone=. jpath ;i{clones
 db=. (>:clone i:'/')}.clone
 jdserver db;'stop'
end. 
)

NB. server summary report
report=: 3 : 0
r=. 'jport db: ',(fread y,'jport'),' ',fread y,'db'
r=. r,LF,fread y,'status'
r=. r,LF,LF,'jds.log:',LF,jdslog_format y;10
r=. r,LF,'std.log:',LF,rdrep y,'std.log'
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

NODE_TIME_jd_=: 10000 5000 20000

NB. * name;op;...- manage node servers
NB. name    - jdscpath/node/name - node server handle
NB. op      - create/start/stop/report/status/delete/handle
NB. nport   - node port that serves client requests
NB. up      - up or testup - which user/pswd file to use
NB. inspect - inspect-yes or inspect-no - enable node inspect
NB. time    - NODE_TIME_jd_ - interval , wait for server port, wait for Jd to finish
NB.
NB.    jdnode name;'create';nport;up;inspect;time NB. create node folder
NB.    jdnode name;'start'           NB. start node server
NB.    jdnode name;'stop'            NB. stop node server
NB.    jdnode name;'report'[;count]  NB. count default 5
NB.    jdnode name;'status'          NB. status;ports;pids - '' for all
NB.    jdnode name;'delete'          NB. kill tasks and delete server-folder
NB.    jdnode name;'handle'          NB. return server-folder
NB.
NB. node start gets jd server ports from jdscpath/server/name
jdnode=: 3 : 0
'arg must be server-name;op[;...]'assert 2<:#y
'name op'=. 2{.y
y=. 2}.y
op=. dltb op
handle=. jdscpath,'node/',(dltb name),'/' NB. node server folder path
if. op-:'status' do. nodestatus name return. end.
if. (op-:'delete')*.0=ftype handle do. i.0 0 return. end.
if. op-:'create' do. nodecreate handle;y return. end.

'not a node-folder' assert 'nodeserver'-:fread handle,'jdclass'
nport=. 0".fread handle,'a_nport'
select. op
case. 'handle' do. handle return.
case. 'start'  do. nodestart handle return.
case. 'stop'   do.
 setstatus handle;'stop'
 killport_jport_ nport
case. 'delete' do.
 killport_jport_ nport
 rmdir_j_ }:handle
case. 'report' do. nodereport handle;;(''-:y){y;5  return.
case.          do. 'invalid op' assert 0
end.
i.0 0
)

NB. * name;port [;...]
nodecreate=: 3 : 0
'handle nport up inspect time'=. y
'handle (node-server-folder) already exists'assert 0=ftype handle
'invalid node port' assert 1024 65535 inrange 0".":nport
'invalid up'assert(<up)e.'up';'testup'
'invalid inspect'assert(<inspect)e.'inspect-yes';'inspect-no'
'invalid time'assert (3=#time)*.(4=3!:0 time)*.(5000<:time)*.120000>:time

check_node''
check_zmq''
check_lz4''

mkdir_j_ handle
'nodeserver' fwrite handle,'jdclass'
setstatus handle;'created'
ferase handle,'std.log'

(":nport)fwrite handle,'a_nport'
(jdscpath,'up/',((up-:'testup')#'test_'),'upfile') fwrite handle,'a_upfilepath'
(":time)fwrite handle,'a_time'
JDP fwrite handle,'a_jdp'

create_node handle;nport;inspect
i.0 0
)

nodestart=: 3 : 0
handle=. y
nport=. 0".fread handle,'a_nport'
if. _1~:getpid_jport_ nport do. 6!:3[0.5 end. NB. time for port to be killed
'nport is in use'assert _1=getpid_jport_ nport
name=. }:(>:(}:handle) i:'/')}.handle

NB. verify jd server(s) exists and are running
jdhandle=. jdscpath,'server/',name,'/'
(jdhandle,' must exist')assert 2=ftype jdhandle
jport=. 0".fread jdhandle,'jport'

db=. fread jdhandle,'db'
clones=. getclones db

jports=. jport+i.>:#clones
b=. (_1 = getpid_jport_ jports)#clones,<db
('required jd servers not running: ',;' ',~each b)assert 0=#b

(": jports)fwrite handle,'a_jports'
setstatus handle;'start'
fork_jtask_ fread handle,'run.txt'
'node server failed to start'assert _1~:getpidx_jport_ nport
i.0 0
)

serverstatus=: 3 : 0
t=. jdscpath_jd_,'server/'
n=. >_2{each<;._1 each {."1 dirtree t,'status'
r=. n,.fread each {."1 dirtree t,'status'
r=. r,.0".each fread each {."1 dirtree t,'jport'
r=. r,.getpid_jport_ each _1{."1 r
if. 0~:#y do. 
 'invalid name'assert (<y) e. n
 r=. (n=<y)#r
end.
/:~r
)

nodestatus=: 3 : 0
t=. jdscpath_jd_,'node/'
n=. >_2{each<;._1 each {."1 dirtree t,'status'
s=. fread each {."1 dirtree t,'status'
r=. n,.s
r=. r,.(0".each fread each {."1 dirtree t,'a_nport'),each 0".each fread each {."1 dirtree t,'a_jports'
a=. (<'start:')=6{.each s
p=. getpid_jport_ each a#_1{."1 r
b=. p (a#i.#a)},.($s)$a:

r=. r,.b
if. 0~:#y do. 
 'invalid name'assert (<y) e. n
 r=. (n=<y)#r
end.
/:~r
)

NB. ts type duc ip port user dan op
nodereport=: 3 : 0
'handle count'=. 2{.(boxopen y),<15
r=. 'nport upfile: ',(fread handle,'a_nport'),' ',fread handle,'a_upfilepath'
r=. r,LF,LF,~'status: ',fread handle,'status'
r=. r,LF,'std.log:',LF,rdrep handle,'std.log'

d=. fread handle,'node.log'
if. _1=d do.
 r=. r,LF,'node.log does not exist',LF
else.
 r=. r,LF,'node.log:',LF
 r=. r,(nodereportsub handle),2 seebox ><;._1 each TAB,each (-count<.+/LF=d){.<;._2 d
end. 

if. fexist 'node.txt' do. r fwrite 'node.txt' end.
r
)

nodereportsub=: 3 : 0
handle=. y
d=. <;._2 fread handle,'node.log'
a=. (>:;d i.each TAB)}.each d
a=. /:~(a i.each TAB){.each a
r=. ('all';~.a),:":each<"0 (#a),+/"1 =a

a=. /:~(>:;d i:each TAB)}.each d
a=. /:~(a i.each TAB){.each a
LF,~2 seebox r,.(~.a),:":each<"0 +/"1 =a
)

names=: 3 : 0
t=. jdscpath_jd_,'server'
d=. (>:#t)}.each {."1 dirtree t
d=. /:~~.(d i.each '/'){.each d
d,.fread each (<t),each '/',each d,/each<'/status'
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

NB. * handle;status
setstatus=: 3 : 0
'handle status'=: y
(status,': ',isotimestamp 6!:0'') fwrite handle,'status'
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

check_certs=: 3 : 0
'.ssh/jserver/key.pem does not exists'       assert 1=ftype '.ssh/jserver/key.pem'
'.ssh/jserver/fullchain.pem does not exists' assert 1=ftype '.ssh/jserver/fullchain.pem'
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

NB. create jds server folder

jds_server_config_template=: 0 : 0
JDP_z_=: '<JDP>'
load JDP,'jd.ijs'
IFJDS_z_=: 1
RELOAD=: JDP,'server/jds/jds_server.ijs' NB. likely debug file
load RELOAD
JDSPATH_z_=:    '<PATH>'
UPFILE_jdup_=: fread '<PATH>upfilepath'
ductable_jdup_=: 0 3$'' NB. each row has dan user cookie
PORT=: <PORT>
DBS=: jdremq_jd_ each ',' strsplit_jd_'<DBS>'
init''
)

NB. path;jport;'test,"foo,bar",~temp/jd/mum'
create_jds=: 3 : 0
'path port dbs'=. y
sport=. ":port
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
nodebin=. fread '~config/nodebinpath'
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
 t fwrite p,'run.bat'
 pw=. hostpathsep p
 ('"PATHrun.bat" > "LOG" 2>&1' rplc 'PATH';pw;'LOG';pw,'std.log') fwrite p,'run.txt'

 a=. fread p,'node/run.bat'
 b=. a rplc '"INSPECT"';default
 b fwrite p,'node/run.bat'
 
 b=. a rplc '"INSPECT"';yes
 b  fwrite p,'node/rundebug.bat'

 a=. fread p,'node/run.txt'
 b=. a rplc 'run.bat';'rundebug.bat'
 b fwrite p,'node/rundebug.txt'

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

t__=: 'nport 3000';'jports 65220 65221 65222';'flags --inspect';'upfile test';'time 5 10 20'

makejson=: 3 : 0
y=. y,(<'JDP ',JDP),<'uppath ',jdscpath_jd_,'up/'
i=. y i.each' '
r=. ':',~each dquote each i{.each y
r=. r,each dquote each dltb each i}.each y
r=. _2}.;r,each <',',LF
r=. '{',LF,r,LF,'}'
)
