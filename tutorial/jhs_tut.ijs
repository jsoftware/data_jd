NB. Jd server overview

assert IFJHS['must run in JHS'

assert 'database'-:jdfread_jd_'~temp/jd/sandp/jdclass'['sandp does not exist - run jdtests'''''

jdadmin 0 NB. clear previous
jdadmin 'sandp'
jd'reads from j' 

load JDP,'api/jjd.ijs' NB. provide Jd service to http clients

NB. J client (J does http post request to server)
''[0 : 0 rplc 'JDP';JDP
this task is now a server to http clients
follow the manual steps in other tasks carefully
first we'll see a J client access this server from a jconsole task

start jconsole task

load JDP,'api/client.ijs' NB. just client.ijs
jdaccess 'sandp u/p localhost:65001'
jd'reads from j'
jd'read  from j'
   
resume tutorial   
)

'sandp'jdadminop_jd_'reads' NB. only allow reads
jdadmin''

''[0 : 0
in the jconsole task verify that read permission has been removed

jd'read  from j'
jd'reads from j'
   
resume tutorial   
)

twin=. 0 : 0
"WGET" ^
--save-headers ^
--output-document="RESULT" ^
--post-data="TEXT;TEXT;%1;u/p;;*%~2" ^
localhost:PORT/jjd

type "RESULT"
)

twin=. twin rplc 'WGET';((jpath'~tools\ftp\wget.exe')rplc'/';'\');'RESULT';((jpath'~temp\result')rplc '/';'\');'PORT';":PORT_jhs_
twin fwrite jpath'~temp/dowget.bat'

tlinux=. 0 : 0
wget \
--save-headers \
--output-document="RESULT" \
--post-data="TEXT;TEXT;$1;u/p;;*$2" \
localhost:PORT/jjd

cat "RESULT"
)

tlinux=. tlinux rplc 'RESULT';(jpath'~temp\result');'PORT';":PORT_jhs_
tlinux fwrite jpath'~temp/dowget.sh'

(jpath'~temp/dowget.bat')rplc'/';'\'
jpath'~temp/dowget.sh'

NB. non-J client (wget.exe) does http post request to server
''[0 : 0
any http client such as wget or curl can access the JD server

note: wget shell script has u/p hardwired user/pswd

Windows command prompt:
>.../j64-801-user\temp\dowget.bat sandp "reads from j"

Linux command prompt:
$ chmod +x .../j64-801-user/temp/dowget.sh
$ .../j64-801-user/temp/dowget.sh sandp "reads from j"

Mac command prompt:
Mac shell script not built
similar to Linux, but with curl instead of wget
exercise for the reader

resume tutorial
)

load JDP,'demo/jhs/jdapp1.ijs' NB. serve JHS browser app jdapp1
NB. browser client of JHS page jdapp1
''[0 : 0
server runs JHS app jdapp1 to provide Jd service to browser
jdapp1 has u/p hardwired
browse to localhost:65001/jdapp1
play with app and then resume tutorial
)

NB. apache client
''[0 : 0
apache/nginx can serve pages with javascript http post requests to a Jd server
these requests require Cross-Origin Resource Sharing

apache/nginx can run cgi task that gets data from a Jd server

demonstration of this capability is beyond the scope of this tutorial
)

NB. create a new server at port 65011
''[0 : 0 rplc 'JDP';JDP
start new jconsole task
load JDP
initserver''        NB. list server configs
initserver'default' NB. default config

resume tutorial
)

NB. access this server from a J client
''[0 : 0 rplc 'JDP';JDP
the task just started is a server on port 65011 to Jd http clients
follow the manual steps in other tasks carefully
first we'll see a J client access this server from a jconsole task

start a new jconsole task to use as a client
or use the one you started as a client in a previous step

load JDP,'api/client.ijs'   NB. not necessary if already loaded
jdaccess'northwind u/p localhost:65011' NB. northwind at port 65011
jd'reads ProductName from Products'

jdaccess'sandp u/p localhost:65001'     NB. sandp at port 65001 
jd'reads from j'

you have a client task accessing
 Jd server on port 65001 with sandp
 Jd server on port 65011 with northwind
 
the 3 tasks are on this machine, but in practice could each be on their own machine

resume tutorial   
)

''[0 : 0
you can access the server as a Jd client
you can also access the server with jijx
the default server has a jijx user of test and password of test
browse to localhost:65011/jijx and login
try the following:

   jdadmin''
   jd'reads ProductName from Products'
)

jdadmin 0 NB. close that new admin gets default state
