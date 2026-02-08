NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. server1 servder example

NB. build simple database
s1_build=: 3 : 0
jdadminnew'simple'
jd'createtable t'
jd 'createcol t a int'
jd 'createcol t byte byte 3'
jdadmin 0 NB. so it can be opened again
)

NB. set simple admin.ijs so users can access
s1_admin=: 3 : 0
r=.    'simple      ; u user0 admin ; *',LF 
r=. r, 'simple-info ; u user0       ; info',LF
r jdsetadmin 'simple' NB. write admin info to admin.ijs
)

NB. build user/pswd test_upfile
NB. server uses an upfile to validate logon
NB. normally this needs to be done in a secure manner
NB. and the password is given seecurely to the user
NB. this simple example has everything in plain view
NB. pswd is encrypted in upfile
s1_up=: 3 : 0
ul=. (jdscpath,'up/test_upfile') conew 'jdup' NB. locale for managing test_upfile
adduser__ul 'admin/funny'
adduser__ul 'u/u' NB. for most ~temp databases
adduser__ul 'user0/user0'
destroy__ul''
i.0 0
)

NB. create server-folder
NB. createforce useful in development as it forces kill of ports
NB. create gets error if ports are in use
NB. server1 is folder name 
NB. 3000 is port for clients to access node
NB. 65220 hardwired j port to service zmq requests from node
NB. simple is database to serve
NB. testup - use test user/pswd file
NB. inspect-no - node does not enable inspect
s1_create=: 3 : 0
jdserver 'createforce';'server1';3000;'simple';'testup';'inspect-no'
)

NB. run server1
s1_run=: 3 : 0
jdserver'run'
)

NB. simple server tests
s1_test=: 3 : 0
echo jdp1=: jdclient 'localhost:3000'
echo jdreq jdp1;'logon simple u u'
echo jdreq jdp1;'info schema'
echo jdreq jdp1;'insert t';'a';6 7 8;'byte';3 3$'qwer' 
echo jdreq jdp1;'read a from t'
echo jdreq jdp1;'logoff'
)

NB. server1 - build/admin/up/create/run
s1_start=: 3 : 0
killport_jport_ 3000
killport_jport_ 65220
s1_build''  NB. build simple db
s1_admin''  NB. set simple admin.ijs
s1_up''     NB. create user/pswd test_upfile
s1_create'' NB. config server1 folder
s1_run''    NB. run server1
)

NB. create server for another db
northwind=: 3 : 0
jdserver 'createforce';'server2';3000;'northwind'
jdserver 'testup' NB. use test_upfile
jdserver'run'
)

northwind_test=: 3 : 0
echo jdp1=: jdclient 'localhost:3000'
echo jdreq jdp1;'logon northwind u u'
echo jdreq jdp1;'info summary'
echo jdreq jdp1;'logoff'
)

