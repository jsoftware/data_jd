0 : 0
prerequisite tutorials:
   jdrt'jds'
   jdrt'jds_client'
)   

0 : 0
how to use node as an https server for jds
node server passes request from client to jd server and returns response

helps you set up a poc (proof of concept) node server
 that provides client browser https access to Jd

if node is not already installed, you need to install it before you proceed
 https://nodejs.org and download and install as required

node https server requires certificate for https
 the poc provides a self-signed certificate that you can use for a quick start
 this will require exception permission when you first browse the page
 the included self-signed certificate was built with:
  https://nodejs.org/en/knowledge/HTTP/servers/how-to-create-a-HTTPS-server/

the poc demonstration has 4 host tasks:
 1. node engine binary (downloaded and installed as above)
 2. jds task serving port 65220
 3. jds task serving port 65221
 4. broswer https://localhost:3000

 host shell and ijs scripts are created to make it easier to manage these tasks
)

0 : 0
jd_x... custom verbs are defined for db jds_db_a
jd_xdo verb lets browser app run arbitrary J sentences
jd_xget verb lets https get run J code that returns html
)

require JDP,'server/node/node_tools.ijs'

fn_custom=:  '~temp/jd/jds_db_a/custom.ijs'
(fread JDP,'server/node/custom.ijs')fwrite fn_custom
fread fn_custom

killport_jport_ 65220  NB. force restart so custom.ijs is loaded
check_jds 65220 NB. make sure jds server is running on port 65220
check_jds 65221

0 : 0
need path to node binary to start node server
on the first run you put the path in file ~temp/jdserver/node/nodebinpath
on subsequent runs the path from that file is used

default install paths for node binary are:
 windows: c:\Program Files\nodejs
 macos:   /usr/local/bin
)

fn=: '~temp/jdserver/node/nodebinpath'

3 : 0 ''
if. fexist fn do. '' return. end.
mkdir_j_ '~temp/jdserver/node'
if. IFWIN do. if. 2~: ftype fp=. 'c:\Program Files\nodejs' do. fp=. _1 end.
else. if. _1 -.@-: fp=. 2!:0 ::_1: 'which node' do. fp=. ({.~ i:&'/') fp end.
end.
if. _1 -.@-: fp do. (jpath fp) fwrite fn
else.
r=. 'you need to run following sentence to set the path to node binary',LF
r=. r,'   (jpath''path to node binary'') fwrite fn'
echo r
end.
)

t=. fread fn
[nodebin=: hostpathsep (t,('/'~:{:t)#'/'),'node',IFWIN#'.exe'
'must exist' assert fexist nodebin
shell_jtask_ '"',nodebin,'" --version'

PORT=: 3000 NB. port served by node application - hardwired in config.js file
spath=: '~temp/jdserver'
cnodearg=: spath;PORT;nodebin
 NB. create folder with all node 3000 server files
[path=: create_node cnodearg
dir path

runit=: ;IFWIN{'run.sh';'run.bat' 
fread path,runit  NB. script to run node app
fread path,'run.txt' NB. fork_jtask arg to run node app server

killport_jport_ PORT NB. kill previous server if any
fork_jtask_ fread path,'/run.txt' NB. start node jds app server on port 3000
i.0 0[6!:3[0.2 NB. give task a chance to get started
pidport_jport_''
fread path,'/logstd.log' NB. stdout/stderr from the node server

0 :0
you might want to run the node server in a terminal window
so you see console.log messages that will help in debugging
to run the server in a terminal window:
 
   killport_jport_ 3000 NB. kill currrent server
   path,runit    NB. command to paste into terminal to run server
)   

0 : 0
server configured to use a self-signed certificate (cert.pem and key.pem)
when you first browse to the page you will have to accept this certificate

browse to: https://localhost:3000

press logon button provide user/pswd credentials to the app
press 'run nxt' button to step through the examples
run your own expressions

jd op xdo (defined in custom.ijs) executes J sentences
)

0 : 0
the server also supports https get requests for a URL
the get request runs the jd_xget verb defined in custom.ijs

browse to: https://localhost:3000/s1/abc/def ghi jkl/foo.html
)

0 : 0
test changes to custom.ijs definition of jd_xget
   edit fn_custom
for example, change line 15 to be: data=. ,LF,.~":23+i.>:?10 10
and save the change

use browser app to load the change in the server:
   xdo jdloadcustom_jd_''

see the effect of the change: https://localhost:3000/s1/abc/def ghi jkl/foo.html
)
