0 : 0
server1 - build/admin/up/create/run/test

server1 provides access to database simple

simple admin.ijs is set for dans simple and simple-info

test_upfile is created for a few users to allow logon

you may need to refocus term window after edit window opens
next step loads and opens script that creates server1
)
load '~addons/data/jd/server/server1.ijs'
0 : 0
edit the script to follow along for a more detailed experience,
   edit '~addons/data/jd/server/server1.ijs'
)
s1_build'' NB. create simple database
NB. note that s1_build ends with jdamin 0 so the server can open it

s1_admin'' NB. set simple admin.ijs - dans/users/ops
s1_up'' NB. create user/pswd upfile
s1_create'' NB. create server1 folder

NB. next step takes a few seconds to start jds and node tasks
s1_run'' NB. start server jds and node tasks
NB. new jds task is running loop for new zmq requests from new node task

s1_test'' NB. run a few client requests on the server

0 : 0
Jd server is 2 tasks:
 node task that serves client requests
 node handles https and is robust with www vagaries
 node task is a reverse-proxy-binary interface to Jd
 https://nodejs.org

 jds (Jd server) task that serves requests from node task
  jds uses zmg for localhost connections from node task
)

dir jdsfolder

0 : 0
jdsfolder has server config files
jds folder has j files
node folder has node files
config is the config arg
jdclass is 'server'
upfilepath is path to user/pswd file (encrypted passwords)
)

jdserver'report'

0 : 0
you can manage a server from the machine that started the server

  jdserver 'get';name NB. set jdsfolder_z_ for server name
  jdserver 'report'  NB. report server1 info
  jdserver 'kill'    NB. kill server1 ports
  jdserver 'run'     NB. start server1
  jdserver 'delete'  NB. kill ports and delete server-folder
)

0 : 0
   jdrt'j_client' NB. run tutorial to see j access to server1
) 
