NB. Copyright 2026, Jsoftware Inc.  All rights reserved.
NB. server1 server example

NB. build simple database
s1_build=: 3 : 0
NB. linux - build simple ok even if simple already open in server
NB. win   - build simple fails if simple already open in server
NB. stop server1 so we can build simple in win
jdserver :: [ 'server1';'delete' NB. stop and delete old server1
jdadminnew'simple'
jd'createtable t'
jd 'createcol t a int'
jd 'createcol t byte byte 3'
jdadmin 0 NB. so it can be opened again
)

NB. build user/pswd test_upfile
NB. server uses an upfile to validate logon
NB. normally this needs to be done in a secure manner
NB. and the password is given securely to the user
NB. this simple example has everything in plain view
NB. pswd is encrypted in upfile
s1_up=: 3 : 0
jdsetuser 'test_upfile';'admin';'funny'
jdsetuser 'test_upfile';'user0';'pswd0'
i.0 0
)

NB. create server-folder
NB. kills any current server tasks
NB. server1 is folder name 
NB. 65220 is j port to service zmq requests from node
NB. 3000 is node port for clients
NB. simple is database to serve
NB. testup - use test user/pswd file
NB. inspect-no - node does not enable inspect
s1_create=: 3 : 0
jdserver 'server1';'delete'
jdserver 'server1';'create';65220;3000;'simple';'testup';'inspect-yes'
)

NB. run server1
s1_run=: 3 : 0
jdserver'server1';'start'
)

NB. server1 - build/admin/up/create/run
s1_start=: 3 : 0
s1_build''  NB. build simple db
s1_up''     NB. create user/pswd test_upfile
s1_create'' NB. config server1 folder
s1_run''    NB. run server1
s1=: 'https://localhost:3000'jdcdefine
echo'   s1=: ''https://localhost:3000''jdcdefine'
)

NB. simple server tests
s1_test=: 3 : 0
s1=. 'https://localhost:3000'jdcdefine
echo s1'logon simple user0 pswd0'
echo s1'info schema'
echo s1'insert t';'a';6 7 8;'byte';3 3$'qwer' 
echo s1'read a from t'
echo s1'each';(<'read from t'),(<'read /lr from t'),(<'reads from t'),(<'reads /lr from t'),(<'reads from t')
echo s1'each';(<'info summary'),(<'info xchema'),<'read from t'
echo s1'free'
)

s1_play=: 3 : 0
s1_start''
s1=: 'https://localhost:3000'jdcdefine
s1'logon simple user0 pswd0'
s1'info summary'
)
