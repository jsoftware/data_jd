NB. tutorial on using node (nodejs) as a https server for jds

0 : 0
this tutorial helps you set up a poc (proof of concept) nodejs server
that provides client browser access to Jd

node (node js) is an https server implemented in javascript
jdnode is a node application that provides client https access to jconsle tasks running Jd
)

0 : 0
if nodejs is not already installed, you need to install if before you can run jdnode

browse to https://nodejs.org and download and install as required
)


load JDP,'server/http/http_tools.ijs'

0 : 0
the poc demonstration requires several host terminal tasks to be run:

1. $ node_binary jd_node_application
2. $ jconsole jds_port_62320_server
3. $ jcossole jds_port_62221_server
4. broswer https:localhost:3000
)

0 : 0
several host shell scripts and ijs scripts are created to make it easier to work with the different host task

these scripts are created in the folder of your choice
 it could be in your J ~temp folder, but a shorter name can be more convenient (e.g. ~/tmp/jdnode)
)

'windows needs work'assert -.'Win'-:UNAME

tmppath=: 'tmp/jdnode'      NB. you may want to change this!
nodebin=: 'nodejs/bin/node' NB. you will probably need to change this!

create_all tmppath;nodebin

dir tmppath

0 : 0
start the nodejs jdnode application

start a terminal task
... $ tmp/jdnode.sh

reports that a Server has been started for port 3000
server actions will be logged to this window
)

0 : 0
browse to https://localhost:3000

play with the page, but not much will work as there are no Jd jds servers
)

0 : 0
start Jd jds server on port 65220

start a terminal task
... $ tmp/jdnode/jds.sh 65220

reports that a Jd server on port 65220 has access to databases a and b
jds actions are logged to this window
)

0 : 0
play with the browser page
)

0 : 0
browser page change service to s2 and note that the jd ops now access a different database in the same server
)

0 : 0
browser page change service to s3 and note that the jd ops now access a server that is not running
)

0 : 0
start Jd jds server on port 65221

start a terminal task
... $ tmp/jdnode/jds.sh 65221

reports that a Jd server on port 652201 as access to databases c and d
jds actions are logged to this window
)

0 : 0
note that browser page can now access s3 databases
)




















