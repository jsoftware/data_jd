0 : 0
how to use node as an https server for Jd jds

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
 2. Jd jds task serving port 65220
 3. Jd jds task serving port 65221
 4. broswer https:localhost:3000

 host shell and ijs scripts are created to make it easier to manage these tasks
)

require JDP,'server/node/node_tools.ijs'

NB. need path to node binary to start node server
NB. on the first run you put the path in file ~temp/jdserver/node/nodebinpath
NB. subsequent runs the path from that file is used

fn=. '~temp/jdserver/node/nodebinpath'

3 : 0''
mkdir_j_ '~temp/jdserver/node' NB. folder for node stuff
if. -.fexist fn do. 
 echo 'run following sentence to set the path to node binary'
 echo '   (jpath''path to node binary - e.g., /usr/local/bin'') fwrite ''',fn,''''
end. 
)

t=. fread fn
[nodebin=: 'node',~t,('/'~:{:t)#'/'
'must exist' assert fexist nodebin
shell_jtask_ nodebin,' --version'

PORT=: 3000 NB. port served by node application - hardwired in config.js file
spath=: '~temp/jdserver'
[path=: create_node spath;PORT;nodebin
dir path

killport PORT NB. kill previous server if any
fread path,'/run.sh'  NB. script to run node app
fread path,'/run.txt' NB. fork_jtask arg to run node app server

fork_jtask_ fread path,'/run.txt' NB. start node jds app server on port 3000
pidport''
fread path,'/logstd.log' NB. stdout/stderr from the server

0 : 0
server configured to use a self-signed certificate (cert.pem and key.pem)
when you first browse to the page you will have to accept this certificate
most things in the app won't work as the Jd servers are probably not running

browse to https://localhost:3000
)

NB. next steps start jds servers on ports 65220 and 65221
NB. errors in the following indicate you need to run tutorial jds to setup the servers
check_jds 65220 NB. start server on port 65220 that was setup in tutorial jds
check_jds 65221 NB. start server on port 65220 that was setup in tutorial jds

NB. play with the brower application - you should now see interactions with Jd
