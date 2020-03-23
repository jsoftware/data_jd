NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

NB.! all asserts should be tested and handled
NB.! all logits should be tested 

require'~addons/net/jcs/jcs.ijs'

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
return.

a=. task i.~ CJ,CW,CRS
a=. 10j0 3j0 ": sr__task,a
a=. a,' ',type,' '
d=. 60{.data
echo a,d
)

logit_z_=: 3 : 0
'type data route'=. y
m=. (10{.type),' : ',(24{.data),' : ',(10{.":route),' : ',isotimestamp 6!:0''
echo m
m fappend LOGFILE
)

NB. run JOBS
run=: 3 : 0
RJOBS__CJ=: WJOBS__CJ=: JOBSTREAM__CJ=: OUT__CJ=: BUSY=: ''
pjclean''
while. 1 do.
  NB.         CJ              CW                               CRS
  e=. 1 + 2* (0~:#OUT__CJ), ((0~:#WJOBS__CJ)*.-.CW e. BUSY) , (0~:#RJOBS__CJ)*.-.CRS e. BUSY
  'rc reads writes errors'=. poll_jcs_ POLL;e;<CJ,CW,CRS
  if.  0=rc do. continue. end.
  getjobs__CJ reads NB. get jobs from client stream and move to JOBS
  runWjob''
  runRjobs''        NB. runa R jobs in idle CRS tasks
  runzjobs reads    NB. runz to get results from completed jobs
  sendrs__CJ writes NB. send OUT to client
end.
)

NB. routines common to different kinds of mtm (insert/all/...)

POLL=: 60000

pjclean=: 3 : 0
for_n. CW,CRS do. runz__n :: 0: 0 end.
)

init_server=: 3 : 0
config_server''
'not a path to a db'assert 'database'-: fread DB,'/jdclass'
LOGFILE_z_=: y,'/mtm_log.txt'
'zmq must be version 4.1.4 or later'assert 414<:10#.version_jcs_''
killp_jcs_''

logit 'start';(":BASE);0

CJ=: jcssraw_jcs_ BASE

CW=: jcst BASE+1
sr__CW=: 0 NB. no route for result
run__CW Serverijs
run__CW 'winit ''',DB,''''

CRS=: jcst BASE+2+i.NCRS
for_c. CRS do.
 sr__c=: 0 NB. no route for result
 run__c Serverijs
 run__c 'rinit ''',DB,''''
end.

mtinfo=: ''

SRS__CJ=:    '' NB. client zmqraw routes
SDATA__CJ=: '' NB. client route data
run''
)

ROPS_z_=: ;:'read reads info list'
IOPS_z_=: ;:'insert'

NB. riw depending on op (read vs insert vs otherupdate)
getopclass_z_=: 3 : 0
op=. dlb y}.~>:y i. ';'
op=. <op{.~op i. ' '
if. op e. ROPS do. 'r' return. end.
if. op e. IOPS do. 'i' return. end.
'w'
)

NB. get jobs and move complete jobs to WJOBS and RJOB queues
NB. runs in JOBS task locale
getjobs_jcs_=: 3 : 0
if. -.y e.~ coname'' do. return. end.
sr=. srcode recv S;(256#' ');256;0
d=. recv S;(20000#' ');20000;0

if. 0=#d do.
 b=. sr~:SRS
 if. *./b do.
  logit 'open';'';sr
  SRS=: SRS,sr
  SDATA=: SDATA,<''
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
 return.
end.  

i=. SRS i. sr
data=. (;i{SDATA),d
SDATA=: (<data) i}SDATA

j=. (data E.~ CRLF,CRLF)i.1 NB. headers CRLF delimited with CRLF at end
if. j>#data do. return. end. NB. do not have headers
hi=. j=. 4+j
h=. j{.data NB. headers
j=. ('Content-Length:'E. h)i.1
assert j<#h NB. must have 
t=. (15+j)}.h
t=. (t i.CR){.t
cl=. _1".t
assert _1~:cl
if. (hi+cl)<#data do. return. end.

NB. data complete - move to job queue - class determines queue
j=. cl{.hi}.data
if. 'r'=getopclass j do.
 RJOBS=: RJOBS,<sr;<j
else.
 WJOBS=: WJOBS,<sr;<j
end.
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
 runa__n rsen t
end.
)

NB. run WJOB in idle CW task
runWjob=: 3 : 0
if. (#WJOBS__CJ)*.-.CW e. BUSY do.
 sr__CW=: ''$;{.>{.WJOBS__CJ
 t=. ;{:>{.WJOBS__CJ
 WJOBS__CJ=: }.WJOBS__CJ
 if. 'i'=getopclass t do.
  BUSY=: BUSY,CW
  log CW;'a';<t
  runa__CW wsen t
 else.
  NB. write op other than insert is special
  while. #BUSY do. NB. CW already added
   'rc reads writes errors'=. poll_jcs_ 60000;(1#~#BUSY);<BUSY NB. wait for BUSY tasks to complete
   if.  0=rc do. 'W2 op blocked' assert 0 end.
   runzjobs reads 
  end.
  BUSY=: BUSY,CW
  log CW;'a';<t
  runa__CW wsen t
  'rc reads writes errors'=. poll_jcs_ 60000;1;<CW NB. wait for op to complete
  if.  0=rc do. assert 0 end.
  runzjobs'' 
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

  NB. have result to send to a client - send it right now
  if. _1=sr__n do.
   logit'discarded';'';srold__n
  else.
   rs=. 'HTTP/1.0 200 OK',CRLF,'Content-Length: ',(":#rs),CRLF,'Content-Type: application/jdserver',CRLF,CRLF,rs
   sr=. srdecode sr__n
   try.
    r=. send_jcs_ S__CJ;sr;(#sr);ZMQ_SNDMORE_jcs_
    if. r~:#sr do.
     'send sr failed' assert 0
    end.
    r=. send_jcs_ S__CJ;rs;(#rs);0
    if. r~:#rs do.
     'send sr data failed' assert 0
    end.
NB. close socket by sending 0 byte to remote http client
NB. ZMQ_STREAM requires identity frame for each send
    r=. send_jcs_ S__CJ;sr;(#sr);ZMQ_SNDMORE_jcs_
    if. r~:#sr do.
     'send sr failed' assert 0
    end.
    send_jcs_ S__CJ;(<0);(0);0
    logit'close';'';sr__n
   catch.
    logit 'snd bad';'';sr__n
   end.
  end.
  sr__n=: _1 NB. do not use again
 end.
end.
)

NB. not used anymore
NB. send OUT to client
sendrs_jcs_=: 3 : 0
if. -.y e.~ coname'' do. return. end.
s=. srdecode {.SRS NB. invalide if more than 1 route
send S;s;(#s);ZMQ_SNDMORE
r=. send S;OUT;(#OUT);0
OUT=: r}.OUT
)
