NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. http server/client tools

jd_jds_http_client_server_tools_jman_=: 0 : 0
jd http client server tools

node https server requires certificate - self signed cert requires exception permission
 https://nodejs.org/en/knowledge/HTTP/servers/how-to-create-a-HTTPS-server/

create .sh and .ijs scripts for starting jdnode
   create_all'tmp/jdnode';'nodejs/bin/node' NB. path_for_scripts ; path_for_node_binary
   
start jdnode server
   $ tmp/jdnode/jdnode.sh
   
start jds server on port 65220
   $ tmp/jdnode/jds.sh 65220
   
 after ctrl_c in server:
   reload'' NB. reload scripts
   init'' or run'' to start serving again

start (optional) jds server on port 65221   
   $ tmp/jdnode/jds.sh 65221


browse: https://localhost:3000

start J client for jds server (not through jdnode)
   jconsole http_client
   loadd JDP,'server/http/examples.ijs'
   
   reload''  NB. reload scripts
   connect'' NB. new socket connection to sever

)

JDP_z_=: 3 : 0''
n=. '/addons/data/jd/'
d=. jpath each 4!:3''
d=. ;d{~(1 i.~;+./each(<n)E. each d)
d{.~(1 i.~n E.d)+#n
)

NB. task utils
NB. jconsole sentences_to_run
jconsole=: 3 : 0
echo y
'needs work to run in other than linux'assert 'Linux'-:UNAME
y fwrite '~temp/jconsole.ijs' 
fork_jtask_ 'x-terminal-emulator -e "\"BINPATH/jconsole\" ~temp/jconsole.ijs"' rplc 'BINPATH';jpath'~bin'
)

do_fork=: 3 : 0
fork_jtask_ 'x-terminal-emulator -e "\"BINPATH/jconsole\" SCRIPT"' rplc 'SCRIPT';y;'BINPATH';jpath'~bin'
)

http_server_config_template=: 0 : 0
load '<JDP>jd.ijs'
load JDP,'server/http/http_server.ijs'
BASE=: <PORT> NB. http port
NOLOG=: <LOG>
LOGFILE_z_=: '<LOGFILE>'
DBS=: ',' strsplit_jd_'<DBS>'
jdadmin each DBS
init''
)

http_server=: 0 : 0 rplc 'JDPATH';JDP;'CONFIG';http_server_config
JDP=: 'JDPATH'
load JDP,'jd.ijs'
load JDP,'server/http/http_server.ijs'
CONFIG
init''
)

NB. JDP;port;log;logfile;dbs
NB. '~Jddev';65220;0;'~temp/65220.txt';'test,"foo,bar",~temp/jd/mum'
create_http_server=: 4 : 0
'jdp port log logfile dbs'=. y
t=. http_server_config_template rplc '<JDP>';jdp;'<PORT>';(":port);'<LOG>';(":log);'<LOGFILE>';logfile;'<DBS>';dbs
t fwrite x,(":port),'.ijs'
)

http_client_config=: 0 : 0
PORT=: 65220
TIMEOUT=: 20000
BUFSIZE=: 50000
CONTEXT=: 'jbin jbin http u/p;'
)

http_client=: 0 : 0 rplc 'JDPATH';JDP;'CONFIG';http_client_config
JDP=: 'JDPATH'
load JDP,'server/http/http_client.ijs'
CONFIG
)

NB. create shell script to run node server
NB. y is path to node executable
create_jdnode_sh=: 4 : 0
t=. '#!/bin/bash',LF,'"NODEBIN" "JS" "CONFIG"' rplc 'NODEBIN';y;'JS';(JDP,'server/jdnode/jdserver.js');'CONFIG';JDP,'server/jdnode/config.js'
f=. x,'jdnode.sh'
r=. t fwrite f
shell'chmod +x "',f,'"'
)

create_jds=: 4 : 0
f=. x,'$1.ijs'
t=. '#!/bin/bash',LF,'"BINPATH/jconsole" "SCRIPT"' rplc 'BINPATH';(jpath'~bin');'SCRIPT';f
f=. x,'jds.sh'
t fwrite f
shell'chmod +x ',f
)

NB. y is folder to hold .sh and .ijs node scripts
NB. 'tmp/jdnode';'nodejs/bin/node'
create_all=: 3 : 0
'p nodebin'=. y
'node binary not found'assert fexist nodebin
p=. jpath p,'/'#~'/'~:{:y
mkdir_j_ p
'needs work to run in windows'assert -.'Win'-:UNAME
p create_jdnode_sh nodebin
p create_http_server JDP;65220;0;'~temp/65220.txt';'a,b'
p create_http_server JDP;65221;0;'~temp/65221.txt';'c,d'
p create_jds ''
)
