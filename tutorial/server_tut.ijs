0 : 0
tutorial has minimal text - use man system as required
   man''
   man'jdserver'
   man'jdsetuser'
   man'jdsetadmin'
)

check_all_jd_'' NB. check that all requirements are met

0 : 0
problems reported by check_all need to be fixed before proceeding
   server_requirements_jd_ NB. info on resolving problems
)

NB.we'll build, configure, and run a server called s1 that serves db simple

load JDP,'test/util/simple.ijs' NB. utilities for simple server

s1_build''         NB. build simple db - study the defn
s1_server''        NB. create s1 server for simple db - study the defn
jdserver's1 start' NB. start s1 server
s1_req''           NB. get client verb for s1 access - s1 uses libcurl to access server
s1'info summary'   NB. access the server

s1_run''           NB. rebuild and start s1 server - study defns
s1'info schema'

NB. s1 server folder created by s1_server line: jdserver's1 create';s1_config
s1_config
0 : 0
65220       - jd base task port
simple      - database
3000        - node task port
testup      - user/password file to use
inspect-yes - node runs with inpsect
node configuraton values
)

jdserver's1 status'
NB. base port pid db status ; node port pid upfile status

NB. s1 is the same as jd except it accesses a server
s1'insert t';'a';2 3
s1'read from t'

NB. s1 x args are cmds for node or requests for special treatment
'eok' s1'bad' NB. Jd error result instead of signaled error

jdserver's1 ports' NB. s1 ports
jdserver's1 pids ' NB. s1 pids

jdserver's1 stop'  NB. orderly shutdown
'eok's1'info summary'

jdserver's1 start' NB. start s1 server
s1_req''
s1'info schema'
'logoff's1'info schema'
'eok' s1'info foo' NB. eok - Jd error rather than signal

'logon simple user0 pswd0;logoff's1'info summary' NB. logon, cmd, logoff
'eok' s1'info foo' NB. eok - Jd error rather than signal

'logon simple user0 pswd0;free's1'info summary' NB. logon, cmd, logoff and destroy libcurl locale
NB. the s1 locale has been destroyed

s1_req'' NB. create new s1 locale
s1'info summary'

jdserver 's1 stop' NB. graceful shutdown
jdserver 's1 report node 5'
jdserver 's1 report base 5'

jdserver's1 start' NB. start s1 server
s1_req''

NB. next step runs a task with xrdspin that takes 3 seconds - stop allows 10 seconds
jdserver's1 stop 10'[beatone 'xrdspin 3'
jdserver's1 pids'
jdserver's1 report node 5' NB. note stop lines in std.log

jdserver's1 start' NB. start s1 server
s1_req''

NB. next step runs a task with xrdspin that takes longer than stop allows
jdserver ::['s1 stop 3'[beatone 'xrdspin 6'
13!:12''
jdserver's1 stop 20' NB. time for shutdown to complete
jdserver's1 pids'
jdserver's1 report node 5'

NB. look at server performance
NB. following can sometimes take many seconds to run
NB. beat starts n tasks that run cnt ops selected from a list of ops 
jdserver's1 start'
LOGON NB. used by tasks started by beat to logon to server
beat 2;100;'list version' NB. 2 tasks ; 100 count ; list version - requests/second
fread 'beat.txt' NB. detail results for each task
beat 2;100;'info foo'
beat 2;100;'read from t'
t=. ('insert t';'a';1234);'read from t';'info summary';'info schema'
beat 2;1000;<t NB. cycle through the ops

0 : 0
   jdrt'j_client' NB. run tutorial to see j access to simple
)

