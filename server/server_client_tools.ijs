NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. server/client tools - used with mtm and http server and http client

echo 0 : 0
http client is the same for http and mtm servers

http server:
   jconsole http_server
   jconsole http_client
   
mtm server:   
   jconsole mtm_server
   jconsole http_client
   
after ctrl_c in server:
   reload'' NB. reload scripts
   init'' or run'' to start serving again
   
in client:
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
fork_jtask_ 'x-terminal-emulator -e "\"/home/eric/j901/bin/jconsole\" ~temp/jconsole.ijs"'
)

http_server_config=: 0 : 0
NOLOG=: 0
DB=: '~temp/jd/http'
BASE=: 65220 NB. http port
LOGFILE_z_=: DB,'/mtm_log.txt'
)

mtm_server_config=: 0 : 0
NOLOG=: 0
DB=: '~temp/jd/mtm'
BASE=: 65220 NB. base port for mtm ports
NCRS=: 2     NB. numbers of CRS tasks (concurrent read tasks)
LOGFILE_z_=: DB,'/mtm_log.txt'
)

http_client_config=: 0 : 0
CONTEXT=: 'jbin jbin;'
PORT=: 65220
TIMEOUT=: 20000
BUFSIZE=: 50000
PORT;TIMEOUT;CONTEXT
)

http_server=: 0 : 0 rplc 'JDPATH';JDP;'CONFIG';http_server_config
JDP=: 'JDPATH'
load JDP,'jd.ijs'
load JDP,'server/http_server.ijs'
CONFIG
init''
)

mtm_server=: 0 : 0 rplc 'JDPATH';JDP;'CONFIG';mtm_server_config
JDP=: 'JDPATH'
load JDP,'mtm/mtm.ijs'
CONFIG
init''
)

http_client=: 0 : 0 rplc 'JDPATH';JDP;'CONFIG';http_client_config
JDP=: 'JDPATH'
load JDP,'server/http_client.ijs'
CONFIG
fixconfig''
reload''    NB. load client scipts
connect''
echo '   msr''info summary'''
echo msr'info summary'
)

NB. wget 'info table'
wget=: 3 : 0
spawn_jtask_ 'wget -O- -q http://127.0.0.1:65220/ --post-data ''json json;JDOP'' > foo.txt'rplc'JDOP';y
fread'foo.txt'
)

wgetfork=: 3 : 0
fork_jtask_ 'wget -O- -q http://127.0.0.1:65220/ --post-data ''json json;JDOP'' 'rplc'JDOP';y
)

curl=: 3 : 0
spawn_jtask_ 'curl http://127.0.0.1:65220/ --data-raw ''json json;JDOP'' > foo.txt'rplc'JDOP';y
fread'foo.txt'
)

NB. create initial mtm db utils
NB. custom derive verb for testing mtm derived col
custom=: 0 : 0 rplc'RPAREN';')' NB. defns for derive verb
derived_bfroma=: 3 : 0
2{."1 jd_get'g a'
RPAREN
)

NB. createmtmdb portbase;crscount
create_mtm_db=: 3 : 0
require JDP,'jd.ijs'
'new'jdadmin'mtm'
custom fappend jdpath_jd_'custom.ijs'
jdadmin 0
echo 'mtm db created with no tables'
echo 'custom.ijs set with derived_bfroma_ verb for derived col test'
echo 'ready to be used by mtm server'
)
