0 : 0
tutorial has minimal text - use man system as required
   man'jd server overview'
   man'jd server requirements'
   man'jdserver'
   man'jdsetuser'
   man'jdsetadmin'
)

0 : 0
a server requires that zmq, node, lz4, and libcurl are installed
the following checks and reports issues that need to be resolved
   man'jd requirements'
)

check_zmq_jdserver_''
check_node_jdserver_''
check_lz4_jdserver_''
check_libcurl_jdserver_''
check_certs_jdserver_''

0 : 0
we'll build, configure, and run a server called simple
node simple task runs client https requests
jds servr1 task runs jd requsts from the node task
)

load JDP,'test/util/simple.ijs' NB. utilities for a simple server

simple_build
simple_build'' NB. build db, set admin and test_upfile, and create jds and node simple folders

dir jdserver'simple';'handle' NB. jds simple config files
dir jdnode  'simple';'handle' NB. node simple config files

0 : 0
an upfile (user/pswd) validates client logon to the node task
test_upfile is used by test servers
upfile is used by production servers
)

jdsetuser'test_upfile'                 NB. list users
jdsetuser'test_upfile';'newbie';'xxxx' NB. add user and encrypted pswd
jdsetuser'test_upfile'
jdsetuser'test_upfile';'newbie'        NB. remove user

jdserver'simple';'start' NB. start jds task to handle requests from node task
jdnode  'simple';'start' NB. start node task to server client https requests

URL
simple=. URL jdclient NB. requests on the url
LOGON
LOGON  simple '' NB. logon for dan simple with user0 and pswd0
simple'info schema'
simple'insert t';'a';6 7 8
simple'read a from t'
'logoff'simple''
'eok' simple'info foo' NB. eok - Jd error rather than signal

'logon simple user0 pswd0;logoff'simple'info summary' NB. logon, cmd, logoff

jdnode   'simple';'report'
jdnode   'simple';'stop'

jdserver 'simple';'report'
jdserver 'simple';'stop'

NB. look at server performance

simple_play'' NB. start server

NB. following can sometimes take many seconds to run
beat 2;100;'list version' NB. 2 tasks ; 100 count ; list version - requests/second
beat 2;100;'info foo'
fread 'beat.txt' NB. detail results for each task
beat 2;100;'read from t'
t=. ('insert t';'a';1234);'read from t';'info summary';'info schema'
beat 2;1000;<t NB. cycle through the ops

0 : 0
   man'jd server debug' NB. debug info
)   

0 : 0
   jdrt'j_client' NB. run tutorial to see j access to simple
)
