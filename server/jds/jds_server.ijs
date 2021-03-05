NB. Copyright 2020, Jsoftware Inc.  All rights reserved.
NB. stripped down from mtm sever

require'~addons/net/jcs/jcs.ijs'

WTIMEOUT=: 60000
SHUTDOWN=: 0 NB. mtm shutdown sets to stop serving new or queue requests

srcode_z_=:   256#.a.i.]
srdecode_z_=: a.{~256 256 256 256 256#:]

logit_z_=: 3 : 0
'type data route'=. y
data=. 36{.(data i. LF){.data
m=. (16{.type),' : ',data,' : ',(10{.":route),' : ',_4}._12{.isotimestamp 6!:0''
(m,LF) fappend LOGFILE
)


NB. global parameters: PORT LOGFILE LOGLEVEL DBS
init=: 3 : 0
'zmq must be version 4.1.4 or later'assert 414<:10#.version_jcs_''
logit 'start jds';(":PORT);0
for_d. DBS do.
 d=. adminp_jd_ >d NB. path to DB folder
 if. fexist d,'/admin.ijs' do. jdadmin d else. 'new' jdadmin d end.
 logit 'database';d;0
end. 
CJ=: jcssraw_jcs_ PORT
coinsert__CJ 'jobs'
SRS__CJ=:      '' NB. client zmqraw routes
SDATA__CJ=:    '' NB. client zmqraw data
SRSOUT__CJ=:   '' NB. list of route;data
run''
)

run=: 3 : 0
while. 1 do.
  e=. 1 + 2*0~:#SRSOUT__CJ
  'rc reads writes errors'=. poll_jcs_ WTIMEOUT__;e;<CJ__ NB. wait for op to complete
  if.  0=rc do. continue. end.
  getjobs__CJ reads NB. get jobs from client stream and and run it now and add result to out stream
  sendrs__CJ writes NB. send responses to client stream
end.
)

coclass'jobs'

RHDR=: 'HTTP/1.0 200 OK',CRLF,'Content-Length: LENGTH',CRLF,'Content-Type: application/jdserver',CRLF,CRLF

NB. add route;data to out q
addout=: 3 : 0
'sr rs'=. y
SRSOUT=: SRSOUT,<sr;(RHDR rplc 'LENGTH';":#rs),rs
)

NB. get jobs and move complete jobs and run it
getjobs=: 3 : 0
sr=. rcv_job y
if. sr=_1 do. return. end.
i=. SRS i. sr
if. i=#SRS do.
 logit'no connection';'';sr
 return.
end. NB. no connection for this route - ignore it 
data=. ;i{SDATA
if. 4>#data do. return. end.

try. 
 assert 'POST'-:4{.data
 j=. (data E.~ CRLF,CRLF)i.1 NB. headers CRLF delimited with CRLF at end
 if. j>:#data do. return. end. NB. do not have headers
 hlen=. j+4
 j=. ('Content-Length:'E. data)i.1
 assert j<#data NB. must have 
 t=. (15+j)}.data
 t=. (t i.CR){.t
 clen=. _1".t
 assert _1-.@-:clen
 if. (hlen+clen)>#data do. return. end.
catch.
 logit 'bad request';'';sr
 SDATA=: a: (SRS i. sr)}SDATA NB. do not use old data - best if client does new connect
 rs=. 3!:1 ,:'jds error';'bad request'
 addout sr;rs
 return.
end.

NB. data complete - move to job queue - class determines queue
i=. SRS i. sr
SDATA=: a: i}SDATA NB. remove old data so next request starts fresh
data=. clen{.hlen}.data

if. SHUTDOWN__ do.
 if. 'm'~:getopclass data do.
  logit 'stopped';'';sr
  SDATA=: a: (SRS i. sr)}SDATA NB. do not use old data - best if client does new connect
  rs=. 3!:1 ,:'jds error';'stopped'
  addout sr;rs
  return.
 end.
end.

NB. http_server runs the job right away - unlike mtm which has WJOBS q
t=. data}.~>:data i.';'
logit'op';t;sr
r=. jds data
addout sr;r
)

NB. result is sr or _1
rcv_job=: 3 : 0
if. -.y e.~ coname'' do. return. end.
sr=. srcode recv S;(256#' ');256;0
d=. recv S;(20000#' ');20000;0
if. 0=#d do.
 b=. sr~:SRS
 if. *./b do.
  logit 'open';'';sr
  SRS=: SRS,sr
  SDATA=: SDATA,a:
 else.
  logit 'close';'';sr
  SRS=:   b#SRS
  SDATA=: b#SDATA
 end.
 _1 return. NB. end of open/close handling
end.

i=. SRS i. sr
if. i=#SRS do.
 logit'invalid connection';'';sr
 _1 return.
end.
data=. (;i{SDATA),d
SDATA=: (<data) i}SDATA
sr
)

NB. send responses to clients
sendrs=: 3 : 0
if. -.y e.~ coname'' do. return. end.
if. 0=#SRSOUT do. return. end.
'sr data'=. >{.SRSOUT
srx=. srdecode sr
r=. send S;srx;(#srx);ZMQ_SNDMORE
if. r~:#srx do.
 logit 'bad snd sr';'';sr
 'send sr failed' assert 0
end. 

r=. send S;data;(#data);ZMQ_SNDMORE
if. r=#data do.
 SRSOUT=:   }.SRSOUT
else.
 logit'short snd short';'';sr
 SRSOUT=: (<sr;r}.data) 0}SRSOUT
end. 
)
