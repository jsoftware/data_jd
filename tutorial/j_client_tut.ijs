NB. simple access from j

load JDP,'test/util/simple.ijs'
simple_build'' NB. build simple server
jdserver'simple';'start'
jdserver'';'status' NB. status for all jd servers - includes port and pid
jdnode  'simple';'start'
jdnode  '';'status'  NB. status for all node servers - includes port and pid(s)
simple=: URL jdclient
LOGON
LOGON simple'' NB. access dan simple with user and pswd

0 : 0
normally pswd should never be displayed (as it just was here)
it should come from manual user entry as a password
logon validates user/pswd against upfile and returns cookie if ok
cookie is used on all subsequent requests
)
simple'info schema'
simple'read from t'
simple'insert t';'a';45
simple'insert t';'a';6 7 8
simple'read from t'
'eok' simple'fubar' NB. accept error
'not an'jdce 'eok' simple'fubar' NB. assert expected error

NB. timeouts - request gets timeout error if:
NB.   no server port is available for the request within 10 seconds
NB. or
NB.   the request has been running in Jd for more than 30 seconds
NB.
NB. next step forks a 30 second Jd op and waits for the result
NB. the task should get a timeout error in 30 seconds
d=. beatoneresult''[beatone 'xrdspin 30'
'did not get expected error text'assert +./'timeout - wait for Jd'E.;{:{:d

NB. next step forks a 20 second Jd op and then this task gets a 10 second timeout
d=. 'eok'simple'info summary'[6!:3[2[beatone'xrdspin 20'
'did not get expected error text'assert +./'timeout - wait for port'E.;{:{:d
d=. beatoneresult'' NB. wait for xrdspin to finish before continuing

'logoff'simple''

'logon simple-ro user0 pswd0'simple''
simple'read from t'
'not an op'jdce 'eok' simple'insert t';'a';23 NB. read only

'logoff'simple''

'logon simple admin funny'simple'' NB. admin user can execute j sentences
simple'admin i.2 3'
simple'admin jdserver''simple'';''report'''
simple'admin fread (jdserver''simple'';''handle''),''jds.log'''
'free'simple'' NB. logoff, cleanup, destroy locale


0 : 0
this client had jd fully loaded
you can also have j client with just the client code
)

t=. 0 : 0 rplc 'JDP';JDP
load 'JDPserver/client/jclient.ijs'
simple=: 'https://localhost:3000' jdclient
'logon simple user0 pswd0'simple''
simple'info schema'
'simple'simple''
)

t fwrite 'jnk.ijs' NB. write script for a new jhs or jqt or jconsole task

NB. start new j task and run: loadd'jnk.ijs' NB. note loadd and not load

0 : 0
you can access simple from any browser
https://localhost:3000
)

jdserver 'simple';'stop'

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
