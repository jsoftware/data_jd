0 : 0
tutorial has minimal text - use man system as required
   man'jd server overview'
   man'jd server requirements'
   man'jdserver'
   man'jdsetuser'
   man'jdsetadmin'
)

0 : 0
a server requires that zmq, node, and lz4 are installed
the following checks and reports issues that need to be resolved
)

check_zmq_jdserver_''
check_node_jdserver_''
check_lz4_jdserver_''

NB. we'll build, configure, and run a server called server1

load JDP,'server/server1.ijs' NB. server1 utilities 

s1_build
s1_build'' NB. build db and create server folder

handle=. jdserver'server1';'handle' NB. server handle is the server folder
dir handle

0 : 0
server folder has server config files
upfilepath is path to user/pswd file (encrypted passwords)
)

fread fread handle,'upfilepath'

jdsetuser'test_upfile' NB. list users
jdsetuser'test_upfile';'auser'
jdsetuser'test_upfile'
jdsetuser'test_upfile';'auser';'guess'

url NB. server1 will serve this url

jdserver'server1';'start'

s1=. url jdclient NB. s1 does jd call on server1
s1'logon simple user0 pswd0' NB. logon to access dan simple with user0/pswd0
s1'info schema'
s1'insert t';'a';6 7 8;'byte';3 3$'qwer' 
s1'read a from t'
s1'free' NB. logoff, cleanup, destroy locale

jdserver 'server1';'report'
jdserver 'server1';'stop'

0 : 0
   jdrt'j_client' NB. run tutorial to see j access to server1
)
