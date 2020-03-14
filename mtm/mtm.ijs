NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

require'~addons/net/jcs/jcs.ijs'

NB. script to load in RW and RO servers when they are started
Serverijs=: 'load ''',JDP,'mtm/mtm_server.ijs'''

HTTPSVR_jcs_=: 0    NB. acts as http server
NOLOG=: 1

srcode_z_=:   256#.a.i.]
srdecode_z_=: a.{~256 256 256 256 256#:]

NB. R server sentence to run with CMD
rsen=: 3 : 0
(('jd''',y,''''),'[mtmfix_jd_ jcs_p0');<mtinfo
)

NB. W server sentence to run with CMD
wsen=: 3 : 0
'(<jd''info summary''),<jd jcs_p0';<y
)

log=: 3 : 0
if. NOLOG do. return. end.
'task type data'=. y
a=. task i.~ CJ,CW,CRS
a=. 10j0 3j0 ": sr__task,a
a=. a,' ',type,' '
d=. ;(0~:L.data){data;{.data
echo a,d
)

logmtm_z_=: 4 : 0
m=. (isotimestamp 6!:0''),' : ',(20{.x),' : ',y,LF
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

NB. path to db folder - for example ~temp/jd/mtm
init=: 3 : 0
'not a path to a db'assert 'database'-: fread y,'/jdclass'
LOGFILE_z_=: y,'/mtm_log.txt'
'zmq must be version 4.1.4 or later'assert 414<:10#.version_jcs_''
killp_jcs_''

DB=: y NB. global
load y,'/mtm_config.ijs' NB. set BASE and NCRS
'start' logmtm 'port ',":BASE

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
NB. only used in http server
SHEADER__CJ=: '' NB. client route header ending position
SCONTENTLEN__CJ=: '' NB. client route content length
run''
)

NB. 0 if op is read type, 1 if op is insert, 2 if other
NB. json support - ignore leading 'json '
wcheck=: 3 : 0
t=. ;(L.y){y;{.y
t=. dlb(5*'json '-:5{.t)}.t
t=. <t{.~t i. ' '
if. t e. 'read';'reads';'info';'rspin' do. 0 return. end.
if. t=<'insert' do. 1 return. end.
2
)

NB. get JOBS stream and move complete jobs to WJOBS and RJOB queues
NB. runs in JOBS task locale
getjobs_jcs_=: 3 : 0
if. -.y e.~ coname'' do. return. end.
sr=. srcode recv S;(256#' ');256;0
d=. recv S;(20000#' ');20000;0

if. 0=#d do.
 b=. sr~:SRS
 if. *./b do.
  'route opened'logmtm ":sr
  SRS=: SRS,sr
  SDATA=: SDATA,<''
  SHEADER=: SHEADER,_1
  SCONTENTLEN=: SCONTENTLEN,0
 else.
  'route closed'logmtm ":sr
  SRS=:   b#SRS
  SDATA=: b#SDATA
  SHEADER=: b#SHEADER
  SCONTENTLEN=: b#SCONTENTLEN
  for_c. BUSY__ do.
   if. sr=sr__c do.
    'result not wanted' logmtm ":sr
    srold__c=: sr NB. for later discarded logmtm
    sr__c=: _1
    break.
   end.
  end.
 end.
 return.
end.  

i=. SRS i. sr

data=. (;i{SDATA),d

NB. if data is complete    - it is moved to a job queue
NB. if data i not complete - it is added to SDATA wait for completion

if. 1=HTTPSVR_jcs_ do.

hi=. i{SHEADER
cl=. i{SCONTENTLEN
while. do.
 if. _1=hi do. NB. get headers
  j=. (data E.~ CRLF,CRLF)i.1 NB. headers CRLF delimited with CRLF at end
  if. j<#data do. NB. have headers
   hi=. j=. 4+j
   h=. j{.data NB. headers
   j=. ('Content-Length:'E. h)i.1
   if. j=#h do. j=. ('Content-length:'E. h)i.1 end.
   if. j<#h do.
    t=. (15+j)}.h
    t=. (t i.CR){.t
    cl=. _1".t
    assert _1~:cl
   else.
    cl=._1
   end.
   SHEADER=: hi i}SHEADER
   SCONTENTLEN=: cl i}SCONTENTLEN
  end.
 end.

 if. (_1=hi) +. (hi+cl)>#data do. break. end.
 j=. mtmdec cl{.hi}.data
 if. 0=wcheck__ j do.
  RJOBS=: RJOBS,<sr;j
 else.
  WJOBS=: WJOBS,<sr;<j
 end.
 data=. (hi+cl)}.data
 SHEADER=: (hi=. _1) i}SHEADER
 SCONTENTLEN=: (cl=. 0) i}SCONTENTLEN
end.

else.

while. HLEN__<:#data do.
 dc=. framelen__ data
 if. dc>#data do. break. end.
  rid=: getrid data NB. !!!! no more rid
  j=. mtmdec HLEN__}.dc{.data
  if. 0=wcheck__ j do.
   RJOBS=: RJOBS,<sr;j
  else. 
   WJOBS=: WJOBS,<sr;<j  
  end.
  data=. ''
end.

end.
SDATA=: (<data) i}SDATA
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
 if. 1=wcheck t do.
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
  NB.! OUT__CJ=: OUT__CJ,rid__CJ streamframe rs
  
  if. _1=sr__n do.
   'result discarded' logmtm ":srold__n
  else.
   if. 1=HTTPSVR_jcs_ do.
   rs=. 'HTTP/1.0 200 OK',CRLF,'Content-Length: ',(":#rs),CRLF,'Content-Type: text/plain',CRLF,CRLF,rs
   else.
   rs=. rid__CJ streamframe rs
   end.
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
    if. 1=HTTPSVR_jcs_ do.
NB. close socket by sending 0 byte to remote http client
NB. ZMQ_STREAM requires identity frame for each send
    r=. send_jcs_ S__CJ;sr;(#sr);ZMQ_SNDMORE_jcs_
    if. r~:#sr do.
     'send sr failed' assert 0
    end.
    send_jcs_ S__CJ;(<0);(0);0
    'route closed'logmtm ":sr__n
    end.
   catch.
    'send result failed' logmtm ":sr__n
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
