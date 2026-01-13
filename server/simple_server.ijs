NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. simple example of jd server

0 : 0
   build''
   config''
   run''
   jtest''
   bashtest''
)

NB. build simple database
build=: 3 : 0
jdadminnew'simple'
jd'createtable t'
jd 'createcol t a int'
jd 'createcol t byte byte 3'

jdsetadmin 'clear'                               NB. rid of default admin
jdsetadmin 'simple-all';'user0 user1 user2';'*'  NB. dan simple-all users that can do all ops
jdsetadmin 'simple-ro';'user0 user1';'read info' NB. dan simple-ro users that can do read ops
jdsetadmin 'load'                                NB. remove old and load new

jdadmin 0 NB. close so it can be opened in server
)

SERVER=: 'jdserver/example' NB. folder to hold server configuration

NB. * 3000;65220;'simple'
NB. node-port ; jds-port ; 1 or more databases
NB. configure server
config=: 3 : 0
sl=: SERVER conew 'jdserver' NB. server locale with server tools
delete__sl'' NB. delete all old stuff in server folder

NB.  3000 is port for clients to access node
NB. 65220 is port node uses to access jds through zmq
NB. dababase to serve (can be a list of multiple dbs)
config__sl 3000;65220;'simple'

NB. build user/pswd table for server
NB. pswd is encrypted in the table
adduser__sl 'admin/funny'
adduser__sl 'user0/user0'
adduser__sl 'user1/user1'
)

NB. y 0 fork jds and y 1 spawn jds
NB. spawn has jconsole and helps in study and debugging
run=: 3 :0
'arg must be 0 or 1'assert y e. 0 1
sj=: SERVER conew 'jdserver' NB. locale with simple config
kill__sl''   NB. kill old ports/tasks
run__sl y
i.0 0
)

simple=: 0 : 0
sl is server locale
   man'jd  jclient'

   cl=: jdconnect 'all user0/user0 localhost:3000'
   jdreq__cl      'info schema'
   jclose__cl     ''

   jtest''
   bashtest''
   test''

browse: https://localhost:3000
)

NB. simple server tests

NB. jd cmds
cmds=: 0 : 0
'info schema'
'insert t';'a';45;'byte';'xxx' 
'insert t';'a';6 7 8;'byte';3 3$'qwer' 
'read from t'
'fubar abc'
'info fubar'
)


NB. run cmds from j on simple server
jtest=: 3 : 0
cl=: jdconnect 'simple-all user0/user0 localhost:3000'
r=. ,.jdreq__cl each ".each <;._2 cmds
jdclose__cl ''
r
)

csh=: 3 : 0
s=. jsonenc_jd_ each ".each <;._2 cmds
rs=. '''',each'''',~each s
rs=. (<'$1/jdreq.sh    $connect '),each rs
rs=. ;rs,each LF
)

bash=: 0 : 0 rplc '<CMDS>';csh'' NB. ,csh''
#!/bin/bash
set -e
connect=$($1/jdconnect.sh simple-all user0/user0 localhost:3000)
<CMDS>
$1/jdclose.sh $connect
)

NB. run cmds from bash on simple server
bashtest=: 3 : 0
load'~addons/data/jd/server/client/jdbashclient.ijs' NB. create jdlient/bash folder
bash fwrite 'bash.sh'
shell'chmod +x bash.sh'
,.jsondec each <;.2 LF-.~shell './bash.sh jdclient/bash'
)

NB. cmd reuslts for j and bash
test=: 3 : 0
(jtest,.bashtest)''
)