NB. Copyright 2019, Jsoftware Inc.  All rights reserved.
NB. mtm server/client helpers - used in mtm_man.ijs demo examples

JDP_z_=: 3 : 0''
n=. '/addons/data/jd/'
d=. jpath each 4!:3''
d=. ;d{~(1 i.~;+./each(<n)E. each d)
d{.~(1 i.~n E.d)+#n
)

NB. task utils
NB. jconsole sentences_to_run
jconsole=: 3 : 0
'needs work to run in other than linux'assert 'Linux'-:UNAME
y fwrite '~temp/jconsole.ijs' 
fork_jtask_ 'x-terminal-emulator -e "\"/home/eric/j901/bin/jconsole\" ~temp/jconsole.ijs"'
)

server=: 0 : 0 rplc 'JDP';JDP
load 'JDPmtm/mtmx.ijs'
echo'   lds'''' NB. reload scripts'
lds''
)

client=: 0 : 0 rplc 'JDP';JDP
load 'JDPmtm/mtmx.ijs'
echo '   ldc'''' NB. reload scripts'
ldc''
)

NB. server utils
lds=: 3 : 0
load JDP,'mtm/mtm.ijs'
init''
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


config_server=: 3 : 0
NOLOG=: 0
DB=: '~temp/jd/mtm'
BASE=: 65220 NB. base port for mtm ports
NCRS=: 2     NB. numbers of CRS tasks (concurrent read tasks)
LOGFILE_z_=: DB,'/mtm_log.txt'
)

NB. client utils
ldc=: 3 : 0
load JDP,'mtm/mtm_client.ijs'
load JDP,'mtm/demo/test.ijs'
init''
)

NB. create initial db utils
NB. custom derive verb for testing mtm derived col
custom=: 0 : 0 rplc'RPAREN';')' NB. defns for derive verb
derive_bfroma=: 3 : 0
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
echo 'custom.ijs set with derive_bfroma_ verb for derived col test'
echo 'ready to be used by mtm server'
)
