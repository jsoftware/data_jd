0 : 0
accessing a jds server from J/wget/curl
   jdrt'jds' NB. prerequisite tutorial
)

NB. error in next line indicates server not set up and you need to first run tutorial jds
fork_jtask_ fread '~temp/jdserver/jds/65220/run.txt' NB. start server set up by jds tutorial

load JDP,'server/jds_client/jds_client.ijs'
jds_client_config 'localhost';65220;'jbin';'jbin';'jds_db_a';'u/p'

msx'info summary' NB. http data to send to jds server
msr'info summary'
msr'droptable f'
msr'createtable f'
msr'createcol f a int'
msr'read from f'
msx'insert f';'a';777
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

NB. the jds server can be accessed by tools such as wget and curl

wgetx'read from f' NB. host command that will be run
wget 'read from f'
wget 'insert f';'a';999 888 777
fread POSTFILE NB. note json encoding of pairs

wget'read from f'

curlx'info summary'
curl 'info summary'
