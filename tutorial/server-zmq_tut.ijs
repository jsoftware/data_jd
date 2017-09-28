NB. lab for jcs Jd server
NB. this lab assumes you are familiar with jcs and Jd

NB. to learn about jcs, run:
NB.    lab'~addons/net/jcs/jcs_lab.ijs'

require'~addons/net/jcs/jcs.ijs'
version_jcs_''   NB. zmq version - error if problems with zmq installation

'Jd sandp db must exist for following steps to work' assert 'database'-:fread'~temp/jd/sandp/jdclass'

NB. next step defines verb to start Jd server with sandp db
jd_server_start=: 3 : 0
c=. jcst y                       NB. start server and create client
run__c'load''jd'''
run__c'jdadmin''sandp'''
run__c'su__SERVER=: ''su:1234''' NB. server superuser pswd
run__c'rpc__SERVER=: rpcjd'      NB. server verb for calls
c
)

NB. by convention jcs Jd servers are in the port range 65100 to 65199
portjd=: 65101

killp_jcs_ portjd         NB. kill any previous server on this port

c=: jd_server_start portjd
access__c=: 'sandp u/p' NB. access info
run__c'info table'      NB. rpcjd called with 'info table'
run__c'reads from j'
'asserttion failure'-: runsu__c etx 'i.23' NB. superuser fails with no password
su__c=: 'su:1234'       NB. set superuser password
runsu__c'i.23'          NB. superuser fails with no password
runsu__c'jdadmin''northwind'''
access__c=: 'northwind u/p'
run__c'info table'


destroy__c''            NB. destroy Jd server client
c=. jcsc portjd         NB. create Jd server client
access__c=: 'sandp u/p' NB. access info
run__c'reads from j'
su__c=: 'su:1234'       NB. set superuser password
kill__c''               NB. kill server task and destroy client locale


0 : 0
you could start a server explicitly in a j task
by doing the same steps as are done in jd_server_start
note: jcss instead of jcst

load'jd'
jdadmin'sandp'
SERVER=: s=. jcss portjd NB. create server locale
rpc__s=: rpcjd
su__s=: 'su:1234' NB. necessary to allow client su
echo'next sentence starts loop running server'
runserver__s''
)
help_jcs_ NB. jcs summary
