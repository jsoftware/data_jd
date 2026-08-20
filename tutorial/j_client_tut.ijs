NB. s1 access from j

load JDP,'test/util/simple.ijs'
s1_run'' NB. fresh build and start of s1 server

0 : 0
normally pswd should never be explicit (as it is s1_req)
it should come from manual user entry as a password
logon validates user/pswd against upfile and returns cookie if ok
cookie is used on all subsequent requests
)

s1'info schema'
s1'read from t'
s1'insert t';'a';45
s1'insert t';'a';6 7 8
s1'read from t'
s1'delete t';'a>0'
s1'insert t';'a';i.10000 NB. test that data encoding works for large arg
'encoding bug'assert (i.10000)-:;{:{:s1'read from t'
'eok' s1'fubar' NB. accept error
'not an'jdce 'eok' s1'fubar' NB. assert expected error

beatoneresult''[beatone 'xrdspin 10' NB. fork request that runs in Jd for 10 seconds

NB. request gets timeout error if it it can not be given to a jd task within a time limit
NB. next step forks a 20 second requests that blocks request from this task 
d=. 'eok's1'info summary'[6!:3[2[beatone'xrdspin 20'
'did not get expected error text'assert +./'timeout - wait for port'E.;{:{:d
6!:3[20 NB. give xrdspin request time to finish

'logoff's1''

'logon simple-ro user0 pswd0's1'' NB. readonly access
s1'read from t'
'not an op'jdce 'eok' s1'insert t';'a';23 NB. read only

'logoff's1''

'logon simple admin funny's1'' NB. admin user can execute j sentences
s1'admin i.2 3'
s1'admin jdserver''s1 report node'''
s1'admin fread (jdserver''s1 handle''),''base/jds.log'''
'free's1'' NB. logoff, cleanup, destroy locale


0 : 0
this client had jd fully loaded
you can also have j client with just the client code
)

t=. 0 : 0 rplc 'JDP';JDP
load 'JDPserver/client/jclient.ijs'
s1=: 'https://localhost:3000' jdclient
'logon simple user0 pswd0's1''
echo '   s1''info schema'''
echo s1'info schema'
)

t fwrite 'jnk.ijs' NB. write script for a new jhs or jqt or jconsole task
NB. start new j task and run: load'jnk.ijs'

0 : 0
you can access s1 from any browser
https://localhost:3000
)

jdserver 's1 stop'

0 : 0
for tools to help debug server, see:
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
