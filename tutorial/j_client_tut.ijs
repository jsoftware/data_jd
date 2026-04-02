NB. server1 access from j

NB. rebuild server1 from scratch
load JDP,'server/server1.ijs'
NB. next starts the server and can take several seconds
s1_start''

s1'logon simple user0 pswd0' NB. access dan simple with user and pswd

0 : 0
normally pswd should never be displayed (as it just was here)
it should come from manual user entry as a password
logon validates user/pswd against upfile and returns cookie if ok
cookie is used on all subsequent requests
)
s1'info schema'
s1'read from t'
s1'insert t';'a';45;'byte';'xxx' 
s1'insert t';'a';6 7 8;'byte';3 3$'qwer' 
s1'read from t'
0 s1'fubar' NB. accept error
'not an'jdce  0 s1'fubar' NB. assert expected error
s1'free' NB. logoff, cleanup, destroy locale

s1_start''
s1'logon simple admin funny' NB. admin user can execute j sentences
s1'admin i.2 3'
s1'admin jdserver''server1'';''report'''
s1'admin fread (jdserver''server1'';''handle''),''jds.log'''
s1'free' NB. logoff, cleanup, destroy locale

NB. a server can be configured to run with 0 or more dbs
jdserver 'nw+simple';'delete'
jdserver 'nw+simple';'create';65220;3000;'northwind,simple';'testup';'inspect-no'
jdserver 'nw+simple';'start'

s1=: 'https://localhost:3000'jdcdefine
s1 'logon simple user0 pswd0'
s1 'info summary'
s1 'logoff'
s1 'logon northwind user0 pswd0'
s1 'info summary'
s1'free' NB. logoff, cleanup, destroy locale

jdserver 'nw+simple';'delete' NB. delete server so dbs are not locked
jdserver 'server1';'delete'

0 : 0
this client had jd fully loaded
you can also have j client with just the client code
)

0 : 0 fwrite 'jnk.ijs' NB. write script for a new jhs or jqt or jconsole task
load JDP,'server/client/jclient.ijs'
s1=: 'https://localhost:3000'jdcdefine
s1'logon simple admin funny' NB. access dan simple with user and pswd
s1'info schema'
s1'free'
)

NB. start new j task and run: loadd'jnk.ijs' NB. note loadd and not load

0 : 0
you can access server1 from any browser
https://localhost:3000
)

0 : 0
for debug info see:
  man'jd server debug'
)

0 : 0
any programming environment can access a Jd server

a client must build a client folder similar to the one for j
this has been done for python3 - others left as an exercise for the reader

   jdrt'python_client' NB. access from python3 client

simplified bat/bash examples use the j client folder for access

   jdrt'shell_client' NB. access from window bat or unix bash
)

