NB. server1 access from j

NB. rebuild server1 from scratch
load'~addons/data/jd/server/server1.ijs'
NB. next start the server and can take several seconds
s1_start''

NB. create new and unique client-folder for managing connection
[jdp1=: jdclient 'localhost:3000'
dir jdp1  

jdreq jdp1;'logon simple user0 user0' NB. access dan simple with user and pswd

0 : 0
normally pswd should never be displayed (as it just was here)
it should come from manual user entry as a password
logon validates user/pswd against upfile and returns cookie if ok
cookie is used on all subsequent requests
)
jdreq jdp1;'info schema'
jdreq jdp1;'read from t'
jdreq jdp1;'insert t';'a';45;'byte';'xxx' 
jdreq jdp1;'insert t';'a';6 7 8;'byte';3 3$'qwer' 
jdreq jdp1;'read from t'
jdreq jdp1;'fubar'
jdreq jdp1;'logon simple-info' NB. change to dan simple-info
jdreq jdp1;'info summary'
jdreq jdp1;'read from t' NB. simple-info only allows info
jdreq jdp1;'logoff' NB. logoff and remove jdp1 folder

jdp1=: jdclient 'localhost:3000' NB. get new connection
jdreq jdp1;'logon simple admin funny' NB. admin user can execute j sentences
jdreq jdp1;'admin i.2 3'
jdreq jdp1;'admin report_jdserver_ 3'
jdreq jdp1;'admin jdslog_format_jdserver_ _'
jdreq jdp1;'logoff'

NB. for lots of jdreq calls with the same client-folder
NB. you can bind the client-folder to the dyadic jdreq
jds1=: (jdclient 'localhost:3000')&jdreq
jds1'logon simple user0 user0'
jds1'info summary'
jds1'read from t'
jds1'logoff'

NB. a server can be configured to run with 0 or more dbs

jdserver 'createforce';'nw+simple';3000;'northwind,simple';'testup';'inspect-no'
jdserver 'run'
jds1=: (jdclient 'localhost:3000')&jdreq
jds1'logon simple u u'
jds1'info summary'
jds1'logoff'
jds1=: (jdclient 'localhost:3000')&jdreq NB. logoff killed previous client-folder
jds1'logon northwind u u'
jds1'info summary'
jds1'logoff'


0 : 0
this client had jd fully loaded
you can also have j client with just the client code
)

0 : 0 fwrite 'jd.jnk' NB. write script for jqt or jconsole
load'~addons/data/jd/server/client/jclient.ijs'
s1=: (jdclient 'localhost:3000')&jdreq
s1'logon simple-all user0 user0' NB. access dan simple-all with user and pswd
s1'info schema'
s1'logoff'
)

NB. start jqt or jconsole and run: loadd'jd.jnk' NB. note loadd and not load

0 : 0
you can access server1 from any browser
https://localhost:3000
)

0 : 0
any programming environment can access server1

first you need to build a client folder similar to the one for j
 python3 has been done - others left as an exercise for the reader

following shows how bash can access server1 by using the j client folder
)

0 : 0  fwrite 'bash_server1.sh'
#!/bin/bash
# $1 path to j client folder, $2 command
printf %s "$2" > $1/post
$1/curl.sh
cat $1/result
)

shell 'chmod +x bash_server1.sh'

jdp1=: jdclient 'localhost:3000' NB. client folder for use by bash
jdreq jdp1;'logon simple-all user0 user0' NB. access dan simple with user and pswd

NB. bash works with jd server with json
shell './bash_server1.sh ',jdp1,' "read from t"'

man'jd server debug'