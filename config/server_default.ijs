NB. default server - do not edit
NB. copy to server_xxx.ijs (same folder) and edit
NB. xxx can be port or database or name

NB. start jconsole
NB.    load 'data/jd'
NB.    initserver'' NB. list config xxx names
NB.    initserver'xxx'

NB. use server jijx with USER/PASS login
NB. clients connect to localhost:PORT on server through ssh tunnel

NB. OKURL to allow only loaded Jd JHS services (e.g., jjd and jdapp1)

NB. Jd server can server single or multiple database files

NB. security depends on doing this right!

'already initialized' assert _1=nc<'SKLISTEN_jhs_' NB. prevent damage to running JHS
PORT_jhs_=: 65011
USER_jhs_=: 'test'
PASS_jhs_=: 'test'
LHOK_jhs_=: 0
BIND_jhs_=: 'localhost'
OKURL_jhs_=: a:
load JDP,'api/jjd.ijs' NB. serve JHS jjd requests from wget clients
jdadmin'northwind'
