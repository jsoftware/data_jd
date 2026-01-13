0 : 0
accessing a jds server from J/wget/curl
   jdrt'jds' NB. prerequisite tutorial
)

load JDP,'server/jds_client/jds_client.ijs'


PORT=: 65220 NB. port with jds service

check_jds PORT
pidport_jport_''
pidfromport_jport_ PORT

0 : 0
config client to use server:  host port fin fout dan u/p
 fin  - format for input arrays - json or jbin (3!:1)
 fout - format for outut arrays - json or jbin
 dan  - data access name (jdaccess)
 u/p  - user/pswd
)
jds_client_config 'localhost';PORT;'jbin';'jbin';'jds_db_a';'u/p'

msrx'info summary' NB. http data to send to jds server
msr'info summary'
msr'droptable f'
msr'createtable f'
msr'createcol f a int'
msr'read from f'
msrx'insert f';'a';777
msr'insert f';'a';777
msr'insert f';'a';888 999
msr'read from f'

0 : 0
try the access from another J task
this task does load Jd and only loads jds_client.ijs

start jconsole
   load '~addons/data/jd/server/jds_client/jds_client.ijs'
   jds_client_config 'localhost';65220;'jbin';'jbin';'jds_db_a';'u/p'
   msr'read from f'
)

NB. change fin/fout to json
jds_client_config 'localhost';PORT;'json';'json';'jds_db_a';'u/p'
msr'info schema'
msr'read from f'
msr'insert f';'a';5 4 3 NB. data is sent to jds server in json format
msr'read from f'

NB. the jds server can be accessed by tools such as wget and curl
NB. wget or curl will fail (interface error) if not installed
NB. if wget fails, try curl and vice versa
wgetx'read from f' NB. host command that will be run
wget etx 'read from f'
wget etx 'insert f';'a';999 888 777

wget etx 'read from f'

curlx'info summary'
curl etx 'info summary'
