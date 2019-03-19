NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

0 : 0
Jd server based on jcs - assumes familiarity with jcs and Jd
to learn about jcs, run lab: Client/Server - parallel each - parallel jobs
from file: ~addons/net/jcs/jcs.ijt
)

require'~addons/net/jcs/jcs.ijs'
version_jcs_''   NB. zmq version - error if problems with zmq installation
'demo dbs must be available' assert 'database'-:fread'~temp/jd/sandp/jdclass'

jdadmin 0 NB. no local dbs
'port portjd'=: PORTBASE_jcs_+i.2
killp_jcs_ port,portjd NB. kill previous use

NB. create script to init a server
'~temp/js.ijs' fwrite~ 0 : 0
load'~addons/net/jcs/jcs.ijs'
load'jd'
jdadmin'sandp'
SERVER=: jcss 65101    NB. create server locale
su__SERVER=: 'su:1234' NB. password for su access
rpc__SERVER=: rpcjd    NB. run args treated as jd args
echo'next sentence starts server loop'
runserver__SERVER''
)

0 : 0
server could be started in jconsole with load of js.ijs
but we use jcs to create a task and then load the script
)

c=: jcst port
runa__c'load''~temp/js.ijs'''               NB. runa as runserver never returns
assert'assertion failure'-:runz__c etx 2000 NB. 2 second timeout is expected 
destroy__c''

c=: jcsc portjd   NB. client locale
access__c=: 'sandp u/p'
run__c'info table'   NB. arg to jd on server
run__c'reads from j'

assert 'assertion failure'-:run__c etx 'i.5'
lse__c               NB. i.5 is not valid jd arg
assert 'assertion failure'-:runsu__c etx 'i.5' NB. password mismatch
su__c=: 'su:1234'    NB. set superuser password'
runsu__c 'i.5'

runsu__c'jdadmin''northwind'''
access__c=: 'northwind u/p'
run__c'info table'
destroy__c''      NB. destroy client local

c=: jcsc portjd   NB. create client locale
access__c=: 'sandp u/p'
run__c'info table'   NB. arg to jd on server

0 : 0
the server can serve multiple local and remote clients
try the following to use the server from a new jconsole task

start Jconsole
  load'~addons/net/jcs/jcs.ijs'
  k=. jcsc 65200          NB. create client locale
  access__k=: 'sandp u/p'
  run__k'reads from j'
)  

su__c=: 'su:1234'    NB. set superuser password
kill__c''            NB. kill server
6!:3[1               NB. wait for server to die (jdtests runs other stuff immediately)
