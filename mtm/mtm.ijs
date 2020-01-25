NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

require'~addons/net/jcs/jcs.ijs'
require'~Jddev/mtm/mtm_util.ijs'

NB. force load of development
ld=: 3 : 0
load'~Jddev/mtm/mtm.ijs'
load'~Jddev/mtm/mtm_util.ijs'
)

config=: 3 : 0
DB=: y
BASE=: 65220 NB. base port for mtm ports
NCRS=:  2     NB. numbers of CRS tasks (concurrent read tasks) 
Serverijs=: 'load ''~Jddev/mtm/mtm_server.ijs''' NB. script to load in servers
)

NB. R server sentence to run with CMD
rsen=: 3 : 0
(('jd''',y,''''),'[mtmfix_jd_ jcs_p0');<mtinfo
)

NB. W server sentence to run with CMD
wsen=: 3 : 0
'jd''info summary''[jd jcs_p0';<y
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

init=: 3 : 0
'zmq must be version 4.1.4 or later'assert 414<:10#.version_jcs_''
killp_jcs_''

CJ=: jcssraw_jcs_ BASE

CW=: jcst BASE+1
run__CW Serverijs
run__CW 'winit ''',DB,''''

CRS=: jcst BASE+2+i.NCRS
for_c. CRS do.
 run__c Serverijs
 run__c 'rinit ''',DB,''''
end.

mtinfo=: ''
run''
)

log=: 3 : 0
'task type data'=. y
a=. task i.~ CJ,CW,CRS
a=. 6j0 3j0 ": rid__task,a
a=. a,' ',type,' '
d=. ;(0~:L.data){data;{.data
echo a,d
)

NB. 0 if op is read type, 1 if op is insert, 2 if other
wcheck=: 3 : 0
t=. dlb;(L.y){y;{.y
t=. <t{.~t i. ' '
if. t e. 'read';'reads';'info';'rspin' do. 0 return. end.
if. t=<'insert' do. 1 return. end.
2
)

NB. get JOBS stream and move complete jobs to WJOBS and RJOB queues
NB. runs in JOBS task locale
getjobs_jcs_=: 3 : 0
if. -.y e.~ coname'' do. return. end.
SROUTE=: recv S;(256#' ');256;0
d=. recv S;(20000#' ');20000;0

if. 0=#d do.
 echo 'client close/reconnect detected - probably should reset state'
end.

JOBSTREAM=: JOBSTREAM,d

while. HLEN__<:#JOBSTREAM do.
 dc=. framelen__ JOBSTREAM
 if. dc>#JOBSTREAM do. break. end.
  rid=. getrid JOBSTREAM
  j=. dec HLEN__}.dc{.JOBSTREAM
  if. 0=wcheck__ j do.
   RJOBS=: RJOBS,<rid;j
  else. 
   WJOBS=: WJOBS,<rid;<j  
  end. 
  JOBSTREAM=: dc}.JOBSTREAM
end.
)

NB. run RJOBS in idle CRS task
runRjobs=: 3 : 0
while. (#RJOBS__CJ)*.#CRS-.BUSY do.
 tasks=. CRS -. BUSY
 n=. {.tasks
 rid__n=: ''$;{.>{.RJOBS__CJ
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
 rid__CW=: ''$;{.>{.WJOBS__CJ
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
    't r'=. {:rs
    mtinfo=: (deb each<"1 t);<,r
   end.
  catch.
   rs=. lse__n
  end.
  OUT__CJ=: OUT__CJ,rid__n streamframe rs
 end.
end.
)

NB. send OUT to client
sendrs_jcs_=: 3 : 0
if. -.y e.~ coname'' do. return. end.
send S;SROUTE;(#SROUTE);ZMQ_SNDMORE
r=. send S;OUT;(#OUT);0
OUT=: r}.OUT
)
