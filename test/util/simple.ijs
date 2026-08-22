NB. Copyright 2026, Jsoftware Inc.  All rights reserved.

load JDP,'test/util/beat.ijs'

0 : 0
performance issues

node performance seems slow (3000 rps vs expected 10000 rps)
but there is a reference to being concerned if it is less than 3000

   beat 1;1000;<'' NB. inspect-no 127.0.0.1
3000   

inspect-no - no difference
node logit noop - no difference
jd zmq socket tcpKeepaliveIdle: 300,... - no difference
)

NB. config for s1 server
NB. jd task port 65220 with db simple
NB. node task port 3000 with parameters
s1_config=: 65220;'simple';3000;'testup';'inspect-no';NODE_TIME_jd_

NB. build database and create server folder
s1_build=: {{
jdadminnew'simple'
jdloadcustom_jd_ fread JDP,'test/util/custom.ijs' NB. set and load custom ops - xdelete xrdspin xwrspin
jd'createtable t'
jd 'createcol t a int'
jdadmin 0 NB. so it can be opened again

NB. set admin.ijs
jdsetadmin'simple';'simple';'user0';'*' NB. simple dan user0 can do all ops
jdsetadmin'simple';'simple-ro';'user0';'info read reads'

jdadmin 0
i.0 0
}}

s1_server=: {{
killport_jport_ 3000 65220 NB. ok testing - be careful in production

NB. add users to test_upfile with encrypted pswd
jdsetuser 'test_upfile';'admin';'funny'
jdsetuser 'test_upfile';'user0';'pswd0'

jdserver's1 delete' NB. delete old s1 server
jdserver's1 create';s1_config
}}

s1_req=: {{
URL=: 'https://127.0.0.1:3000'
LOGON=: 'logon simple user0 pswd0'
s1=: URL jdclient NB. s1 accesses server with libcurl
LOGON  s1 '' NB. logon to server
}}

s1_run=: {{
s1_build''
s1_server''
jdserver's1 start'
s1_req''
}}
