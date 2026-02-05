NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. manage node-jd-DB server

coclass'jdserver'
coinsert'jd'

jdserver_z_=: jdserver_jdserver_

man_jd_server=: 0 : 0
name    - server folder name - last name in folder-path
port    - node port that services client requests
dbs     - 0 or more db names separated by ,
up      - up or testup - which user/pswd file to use
inspect - inspect-yes or inspect-no - enable node inspect
   jdserver 'create';name;port;dbs;up;inspect
   jdserver 'createforce';... NB. kill ports before create - handy in development
   jdserver'get';name NB. get full server-folder path

create/createforce/get set jdsfolder_z_ as full path to server-folder
jdsfolder is a handle to the server
   
   serverdebug_jdserver_=: 1 NB. 1 for j server task visible in jconsole

   jdserver'run'    NB. start server
   jdserver'report'
   jdserver'kill    NB. kill server tasks
   jdserver'delete' NB. kill and delete server-folder

example use in : ~addons/data/jd/server/server1.ijs
)

man_jd_server_debug=: 0 : 0
*** debug jds - on the server machine
   fread jdsfolder,'/node/logstd.log'
   fread jdsfolder,'jds.log'

jds running in a visible jconsole task can be useful

if not running in visible jconsole task
   jdserver'kill'
   serverdebug_jdserver_=: 1
   jdserver'run'

ctrl+c - interrupt server zmq loop
   RELOAD NB. jds main file
edit RELOAD - e.g. add (decho jdsq__=: y) line at start jds defn   
   load 'jd' 
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

3 :0''
if. _1=nc<'serverdebug' do. serverdebug=: 0 end.
)

NB. * op;...
NB. server manage
jdserver=: 3 : 0
op=. dltb;{.y=. boxopen y
if. 'create'-:op do. create }.y return. end.
if. 'createforce'-:op do.
 killport_jport_ each 65220,0".":;2{y
 create }.y
 return.
end.
if. 'get'-:op do.
 t=. jdscpath,'server/',(;1{y),'/' 
 'not a server-folder' assert 'server'-:fread t,'jdclass'
 jdsfolder_z_=: t 
 return.
end.
'not a server-folder' assert 'server'-:fread jdsfolder,'jdclass'
select. op
case. 'run' do.
 run''
 return.
case. 'kill' do.
 kill''
case. 'delete' do.
 delete''
case. 'report' do.
 JDSPATH=: jdsfolder NB. used from server and from jdreq
 report''
 return.
case.       do. 'invalid op' assert 0
end.
i.0 0
)

NB. * port;dbs;up;inspect
NB. multiple dbs separated by ,
NB. up is up or testtup (upfilepath)
NB. inspect is inspect-yes or inspect no - node inspect
NB. create jdserver-folder
create=: 3 : 0
erase'jdsfolder_z_'
'need 5 args'assert 5=#y
'name nport dbs up inspect'=. y
name=. dltb name
nport=. 0".":nport
jport=. 65220
'invalid port' assert (nport>:1024)*.nport<:65535
dbs=. }.;',',each~.deb each ','splitstring dbs
'invalid dbs'assert -.RESERVEDCHARS e. dbs-.','

'invalid up'assert(<up)e.'up';'testup'
'invalid inspect'assert(<inspect)e.'inspect-yes';'inspect-no' 
check_nodebinpath''
'zmq must be version 4.1.4 or later'assert 414<:10#.version_jcs_''
jdsfolder_z_=: jdscpath,'server/',name,'/'
'server ports in use - delete?' assert _1=;pidfromport_jport_ each jport,nport
rmdir_j_ :: [ }:jdsfolder
mkdir_j_ jdsfolder
'server' fwrite jdsfolder,'jdclass'
mkdir_j_ jdsfolder,'jds'
mkdir_j_ jdsfolder,'node'
(5!:5<'y')fwrite jdsfolder,'config'
cjport=: ":jport
cnport=: ":nport
cjport fwrite jdsfolder,'jds/jport'
cnport fwrite jdsfolder,'node/nport'
create_jds  jdsfolder;cjport;dbs
create_node jdsfolder;cnport;cjport;inspect
(jdscpath,'up/',((up-:'testup')#'test_'),'upfile') fwrite jdsfolder,'upfilepath'
i.0 0
)

delete=: 3 : 0
kill''
rmdir_j_ }:jdsfolder
erase'jdsfolder_z_'
)

NB. set jport etc from server
setup=: 3 : 0
pfj=. jdsfolder,'jds/'
jport=. 0".fread pfj,'jport'
pfn=. jdsfolder,'node/'
nport=. 0".fread pfn,'nport'
jport;nport;pfj;pfn
)

adduser=: 3 : 0
uj=: server conew'jdup'
adduser__uj 'admin/funny'
adduser__uj'user0/user0'
)

NB. last y records from jdslog - '' default is 5
jdslog_records=: 3 : 0
d=. fread JDSPATH,'jds.log'
if. d=_1 do. 'jds.log is empty',LF return. end.
t=. -;(y-:''){y;5
;t{.<;.2 d
)

jdslog_format=: 3 : 0
d=. fread JDSPATH,'jds.log'
if. d=_1 do. 'jds.log is empty',LF return. end.
t=. -(+/LF=d)<.;(y-:''){y;5
t=. t{.<;._2 d
2 seebox ><;._1 each TAB,each t
)


NB. * number of latest log records to report
report=: 3 : 0
r=. '   jdslog_records_jdserver_ ',(":;(y-:''){y;5),' NB. last n records'
r=. r,LF,jdslog_format y
r=. r,LF,'server started: ',fread JDSPATH,'start'
r=. r,LF,fread JDSPATH,'config'
r=. r,LF,LF,'   pidport_jport_'''''
r=. r,LF,,LF,.~":pidport_jport_''
r=. r,LF,'   fread JDSPATH,''/node/logstd.log'''
r=. r,LF,fread JDSPATH,'/node/logstd.log'
)

NB. kill server tasks/ports
kill=: 3 : 0
'jport nport pfj pfn'=. setup''
killport_jport_ jport
killport_jport_ nport
i.0 0
)

certerror=: 0 : 0
node https server requires cert.pem and fullchain.pem files in .ssh/jserver
for testing/development you can install self-signed certificates
   install_self_signed_certs_jdserver_''
)

NB. start jds and node tasks
run=: 3 : 0
path=. jdsfolder
'jport nport pfj pfn'=. setup''
'server ports in use - delete?' assert _1=;pidfromport_jport_ each jport,nport
'upfile does not exist'  assert 1=ftype fread jdsfolder,'upfilepath'
certerror assert 1=;ftype each '.ssh/jserver/key.pem';'.ssh/jserver/fullchain.pem'

ferase pfj,'logfile.log' NB. remove old jds log file

if. serverdebug do.
 spawn_jtask_'x-terminal-emulator -e "\"j9.6/bin/jconsole\" \"',(jpath path,'jds/run.ijs'),'\" "'
else.
 fork_jtask_ fread pfj,'run.txt'
end.
fork_jtask_ fread pfn,'run.txt'

NB. jds spawn won't finish until ???
if. -.serverdebug do. 'jd server failed to start'   assert _1~:pidfromport_jport_ jport end.
'node server failed to start' assert _1~:pidfromport_jport_ nport

(isotimestamp 6!:0'') fwrite jdsfolder,'start'
(fread jdsfolder,'jds.log'),LF,fread jdsfolder,'node/logstd.log'
)

check_nodebinpath=: 3 : 0
fn=. '~config/nodebinpath'
if. 1=ftype fn do. if. 1= ftype fread fn do. return. end. end.
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
