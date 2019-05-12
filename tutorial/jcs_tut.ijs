NB. Jd server based on jcs - assumes familiarity with jcs and Jd
NB. see: Client/Server - parallel each - parallel jobs : ~addons/net/jcs/jcs.ijt
load JDP,'server/jcs_server.ijs' NB. jcs server utilities
require'~addons/net/jcs/jcs.ijs'
'~addons/net/jcs must be updated'assert 0~:nct_jcs_ :: 0: ''

version_jcs_''   NB. zmq version - error if problems with zmq installation

f=. '~temp/sa.ijs'
jcs_start_fix f;65200;'su:1234';'jdadminnew''sa_test'''
fread f
NB. 65200 binds localhost - '*:65200' binds any
jcs_start f

sa=. jcsc 65200
jdaccess__sa 'sa_test u/p'
jd__sa'gen test f 2'
jd__sa'reads from f'
'unsupported'jdae__sa'info xxx'
jdlast
jdlasty

0 : 0
start a jconsole task to connect to this server
   load'~addons/net/jcs/jcs.ijs'
   sa=. jcsc 65200
   jdaccess__sa'sa_test u/p'
   jd__sa'reads from f'
   destroy__sa''
)

destroy__sa''
sa=. jcsc 65200 NB. connect to the server again
jdaccess__sa 'sa_test u/p'
jd__sa'reads from f'

su__sa=: 'su:1234' NB. must match su in server  - superuser
runsu__sa 'jdadminnew''fubar''' NB. create new db in server

jdaccess__sa'fubar u/p'
jd__sa'gen test f 4'
jd__sa'reads from f'

jdaccess__sa'sa_test u/p'
jd__sa'reads from f'

kill__sa'' NB. exit server (superuser)
