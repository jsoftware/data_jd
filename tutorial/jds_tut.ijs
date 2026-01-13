NB. configure and run a Jd server

NB. you may need to refocus term window after an edit window is opened
NB. next step loads and opens script that creates/configures/runs a simple server
(load,edit) '~addons/data/jd/server/simple_server.ijs' 
NB. study the sections in the script as they are desribed in this lab
build'' NB. create the simple database
NB. note that build ends with jdamin 0 so the server can open it

0 : 0
Jd server is 2 tasks:
 node task that serves client requests
 node handles https and is robust with www vagaries
 node task is a reverse-proxy-binary interface to Jd
 https://nodejs.org

 jds (Jd server) task that serves requests from node task
  jds uses zmg for localhost connections from node task
)

NB. 'simple-server.ijs has set SERVER as the path for config files'
SERVER

config'' NB. config server

dir SERVER

0 : 0
jds folder has jds config files
node folder has node config files
config is the config arg
jdclass is 'server'
upclass is user/pswd file with encrypted passwords
)

dir SERVER,'/jds'
dir SERVER,'/node'

NB. next step takes a few seconds to start node task and jds task in jconsole
NB. refocus this task after the jconsole task start
run 1 NB. run the server with jds in spawned jconsole task
NB. new jconsole task is running Jd server - it is in loop waiting for zmq requests

NB. sl is locale for managing server
nodelog__sj'' NB. node stdout - important if the node task failed
jdslog__sj'' NB. jds log

NB. use this task as a j client to the server
NB. connect to the server at localhost:3000 to use dan simple-all and user0
cl=: jdconnect 'simple-all user0/user0 localhost:3000'
jdreq__cl'info summary' NB. request jd op on server
jdreq__cl'info schema'
jdreq__cl'read from t'
jdclose__cl''

cmds NB. commands for server

jtest''    NB. run cmds
bashtest'' NB. run cmds from bash shell 

NB. bashtest has installed bash scripts in ~/jdclient/bash

0 : 0
run bash client manually

start terminal task
$ connect=$(jdclient/bash/jdconnect.sh simple-all user0/user0 localhost:3000)
$ jdclient/bash/jdreq.sh $connect '"info summary"'
$ jdclient/bash/jdclose.sh $connect
)

0 : 0
get bash scripts when you can not run bashtest

start terminal task
$ mkdir -p jdclient/bash
$ cd jdclient/bash
$ curl -k -o bash.tar https://localhost:3000/bash.tar
$ tar -xf bash.tar
$ cd ~
)

pidport_jport_ '' NB. pid/port table - note 3000 and 65220

man'jd server debug'
