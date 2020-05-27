NB. Copyright 2020, Jsoftware Inc.  All rights reserved.

require'~addons/net/jcs/jcs.ijs'

NB. http://api.zeromq.org/4-1:zmq-socket - zmq http server - zmq_stream

NB.! all asserts should be tested and handled
NB.! all logits should be tested 

0 : 0
CJ locale (jobs locale) handles client request/response (zmq_stream socket)

http complete requests are put on R or W job queue

when job is finished the result is put on the CJ result queue

sr indicates encoded (int) socket route - srx is decoded 

client open connection adds sr to SRS__CJ
client close connectin removes it

request with bad format (not POST, bad counts, short) has response added to CJ result queue
and the connection sr is removed from SRS__CJ to prevent future requests on that route



response starts with ({.a.) to differ from jbin or json
client on getting {.a. should do connect to help ensure things are clean

client that gets BAD_REQUEST response must do connect again

request that does is not connected (sr not in SRS) is ignored
)

reload=: 3 : 0
load JDP,'mtm/mtm.ijs'
)

POLL=: 60000
WTIMEOUT=: 60000 NB. W (non-insert) - wait for other tasks to finish - wait for the W op to finish
SHUTDOWN=: 0 NB. mtm shutdown sets to stop serving new or queue requests

NB. script to load in RW and RO servers when they are started
Serverijs=: 'load ''',JDP,'mtm/mtm_server.ijs'''

srcode_z_=:   256#.a.i.]
srdecode_z_=: a.{~256 256 256 256 256#:]

NB. R server sentence to run with CMD
rsen=: 3 : 0
(('jdserver''',y,''''),'[mtmfix_jd_ jcs_p0');<mtinfo
)

NB. W server sentence to run with CMD
wsen=: 3 : 0
'(<jd''info summary''),<jdserver jcs_p0';<y
)

log=: 3 : 0
if. NOLOG do. return. end.
'task type data'=. y
data=. data}.~>:data i.';'
a=. ":task i.~ CJ,CW,CRS
logit (type,' ',a);data;sr__task
)

logit_z_=: 3 : 0
'type data route'=. y
data=. 36{.(data i. ';'){.data
m=. (16{.type),' : ',data,' : ',(10{.":route),' : ',_4}._12{.isotimestamp 6!:0''
echo m
(m,LF) fappend LOGFILE
)

NB. run JOBS
run=: 3 : 0
RJOBS__CJ=: WJOBS__CJ=: OUT__CJ=: BUSY=: ''
pjclean''
while. 1 do.
  e=. 1 + 2* (0~:#SRSOUT__CJ), ((0~:#WJOBS__CJ)*.-.CW e. BUSY) , (0~:#RJOBS__CJ)*.-.CRS e. BUSY
  'rc reads writes errors'=. poll_jcs_ POLL;e;<CJ,CW,CRS
  if.  0=rc do. continue. end.
  getjobs__CJ reads NB. get jobs from client stream and move to JOBS
  runWjob''
  runRjobs''        NB. runa R jobs in idle CRS tasks
  runzjobs reads    NB. runz to get results from completed jobs
  sendrs__CJ writes NB. send responses to client stream
end.
)

NB. routines common to different kinds of mtm (insert/all/...)


pjclean=: 3 : 0
for_n. CW,CRS do. runz__n :: 0: 0 end.
)

init=: 3 : 0
'not a path to a db'assert 'database'-: fread DB,'/jdclass'
'zmq must be version 4.1.4 or later'assert 414<:10#.version_jcs_''
killp_jcs_''

logit 'start mtm';(":BASE);0
logit 'database';DB;0

CJ=: jcssraw_jcs_ BASE
coinsert__CJ 'jobs'

CW=: jcst BASE+1
runicount__CW=: runwcount__CW=: 0
sr__CW=: 0 NB. no route for result
run__CW Serverijs
run__CW 'winit ''',DB,''''

CRS=: jcst BASE+2+i.NCRS
for_c. CRS do.
 runrcount__c=: 0
 sr__c=: 0 NB. no route for result
 run__c Serverijs
 run__c 'rinit ''',DB,''''
end.

mtinfo=: ''

SRS__CJ=:      '' NB. client zmqraw routes
SDATA__CJ=:    '' NB. client zmqraw data
SRSOUT__CJ=:   '' NB. list of route;data
run''
)

MOPS_z_=: <'mtm'
ROPS_z_=: ;:'read reads info list rspin'
IOPS_z_=: ;:'insert'

NB. riw depending on op (read vs insert vs otherupdate)
getopclass_z_=: 3 : 0
op=. dlb y}.~>:y i. ';'
op=. <op{.~op i. ' '
if. op e. ROPS do. 'r' return. end.
if. op e. IOPS do. 'i' return. end.
if. op e. MOPS do. 'm' return. end.
'w'
)

NB. run RJOBS in idle CRS task
runRjobs=: 3 : 0
while. (#RJOBS__CJ)*.#CRS-.BUSY do.
 tasks=. CRS -. BUSY
 n=. {.tasks
 sr__n=: ''$;{.>{.RJOBS__CJ
 t=. ;{:>{.RJOBS__CJ
 RJOBS__CJ=: }.RJOBS__CJ
 BUSY=: BUSY,n
 log n;'a';<t
 runrcount__n=: >:runrcount__n
 runa__n rsen t
end.
)

NB. run WJOB in idle CW task
NB. W insert can run while other tasks are running
NB. W (non-insert) can not run while other tasks are runnin
NB. W (non-insert) can run only when all other tasks are idle
NB. W (non-insert) task running blocks starting any other task
runWjob=: 3 : 0
if. (#WJOBS__CJ)*.-.CW e. BUSY do.
 sr__CW=: ''$;{.>{.WJOBS__CJ
 t=. ;{:>{.WJOBS__CJ
 WJOBS__CJ=: }.WJOBS__CJ
 if. 'i'=getopclass t do.
  BUSY=: BUSY,CW
  log CW;'a';<t
  runicount__CW=: >:runicount__CW
  runa__CW wsen t
 else.
  if. #BUSY do. logit 'W blocked';'';0 end.
  while. #BUSY do.
   'rc reads writes errors'=. poll_jcs_ WTIMEOUT;(1#~#BUSY);<BUSY NB. wait for BUSY tasks to complete
   if.  0=rc do. 'W blocked timeout' assert 0 end.
   runzjobs reads
  end.
  BUSY=: BUSY,CW
  log CW;'a';<t
  runwcount__CW=: >:runwcount__CW
  runa__CW wsen t
  'rc reads writes errors'=. poll_jcs_ WTIMEOUT;1;<CW NB. wait for op to complete
  if.  0=rc do.
   logit'W run timeout';t;0
   'W run timeout'assert 0
  end.
  runzjobs reads
  for_n. CRS do.
   run__n 'rinit ''',DB,'''' NB. CRS task initialized while CW is idle
  end.
  mtinfo=: '' NB. R tasks are current
 end.
end. 
)

NB. get results from completed jobs
runzjobs=: 3 : 0
for_n. BUSY do.
 if. n e. y do.
  log n;'z';''
  BUSY=: BUSY-.n
  try.
   rs=. runz__n 0
   if. n=CW do.
    'a b'=. rs 
    't r'=. {:a
    mtinfo=: (deb each<"1 t);<,r
    rs=. b NB. {} or i.0 0
   end.
  catch.
   rs=. lse__n
  end.
  if. _1=sr__n do. logit'discarded';'';srold__n continue. end.
  addout__CJ sr__n;rs
  sr__n=: _1 NB. do not use again
 end.
end.
)

NB. CJ locale manages zmq_stream connections with clients
NB. jobs locale is coinsert in CJ local
coclass'jobs'

RHDR=: 'HTTP/1.0 200 OK',CRLF,'Content-Length: LENGTH',CRLF,'Content-Type: application/jdserver',CRLF,CRLF

NB. add route;data to out q
addout=: 3 : 0
'sr rs'=. y
SRSOUT=: SRSOUT,<sr;(RHDR rplc 'LENGTH';":#rs),rs
)

NB. get jobs and move complete jobs to WJOBS and RJOB queues
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
 rs=. 3!:1 ,:'mtm error';'bad request'
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
  rs=. 3!:1 ,:'mtm error';'stopped'
  addout sr;rs
  return.
 end.
end. 

select. getopclass data
case. 'r' do. RJOBS=: RJOBS,<sr;<data
case. 'm' do. mtm_op data;sr
case. do. WJOBS=: WJOBS,<sr;<data
end.
)

mtm_op=: 3 : 0
'data sr'=. y
 d=. dltb (>:data i.';')}.data
 logit 'mtm';d;sr
 rs=. ,:d;''
 select. d
 case.'mtm report' do.
  rs=. 0 2$0
  c=. CW_base_
  rs=. rs,'#W 1';runwcount__c
  rs=. rs,'#I 1';runicount__c
  for_n. CRS_base_ do.
   rs=. rs,('#R ',":2+CRS_base_ i. n);runrcount__n
  end.
  rs=. rs,'#WJOBS';#WJOBS
  rs=. rs,'#RJOBS';#RJOBS
  rs=. rs,'#SRS';#SRS
  rs=. rs,'#SRSOUT';#SRSOUT
 case.'mtm stop' do. NB. stop serving new requests and flush job queues
  SHUTDOWN__=: 1
  NB.!!! need to flush job queues
 case.'mtm start' do. NB. start serving new requests
  SHUTDOWN__=: 0
 case.'mtm kill' do. NB. kill tasks
  SRSOUT=: WJOBS=: RJOBS=: BUSY=:''
  addout sr;3!:1 rs
  'rc reads writes errors'=. poll_jcs_ WTIMEOUT__;2;<CJ__ NB. wait for op to complete
  sendrs writes
  killp_jcs_''
  exit''
 end.
 addout sr;3!:1 rs
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
  for_c. BUSY__ do.
   if. sr=sr__c do.
    logit 'unwanted';'';sr
    srold__c=: sr NB. for later discarded logit
    sr__c=: _1
    break.
   end.
  end.
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

NB. unused
NB. close sr 
NB. close socket by sending 0 byte to http client
NB. ZMQ_STREAM requires identity frame for each send
xxxclosesr=: 3 : 0
t=. srdecode y 
r=. send S;t;(#t);ZMQ_SNDMORE
if. r~:#t do.
 logit'bad snd sr close';'';y
else. 
 send S;(<0);(0);ZMQ_SNDMORE NB.!!! ??? 0
end. 
logit'snd close';'';y
)
