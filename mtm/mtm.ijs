NB. Copyright 2019, Jsoftware Inc.  All rights reserved.

require'~addons/net/jcs/jcs.ijs'
require'~Jddev/mtm/mtm_common.ijs'

ld=: 3 : 0
load'~Jddev/mtm/mtm.ijs'
load'~Jddev/mtm/mtm_common.ijs'
)

mtm_config=: 3 : 0
'zmq must be version 4.1.4 or later'assert 414<:10#.version_jcs_''
tlens=: '' NB.!
DB=: 'mtm'
PJOBS=: 65220 NB. port for new jobs and results
)

NB. P... are ports
NB. C... are locales for ports
mtm_init=: 3 : 0
killp_jcs_''
mtm_config''

CJ=: jcssraw_jcs_ PJOBS

CW=: jcst PJOBS+1

run__CW 'load''~Jddev/jd.ijs'''
run__CW 'jdadmin''',DB,''''

d=. run__CW'jd''info summary'''
tlens=: ":,>{:{:d

d=. run__CW 'jd''info schema'''
'varbyte not supported'assert -.(<'varbyte')e.deb each<"1>2{"1{:d

CRS=: jcst PJOBS+2+i.2
for_c. CRS do.
 run__c 'load''~Jddev/jd.ijs'''
 run__c 'jdadminro''',DB,''''
end. 

NB. mtm_run''
)

POLL=: 1e6 NB.!


necho=: [
NB. necho =: echo

pjclean=: 3 : 0
for_n. CW,CRS do. runz__n :: 0: 0 end.
)

NB. get JOBS stream and move complete jobs to JOBS
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
  if. 32=3!:0 j do.
   WJOBS=: WJOBS,<rid;<j  
  else.
   RJOBS=: RJOBS,<rid;j
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
 echo rid
 t=. ;{:>{.RJOBS__CJ
 echo 'runa: ',(;n),' ',t
 RJOBS__CJ=: }.RJOBS__CJ
 BUSY=: BUSY,n
 runa__n ('jd''',t,''''),'[jdadmintlen_jd_ ''',(":tlens),''''
end.
)

NB. run WJOBS in idle CW task
NB. insert ops return new info summary
runWjobs=: 3 : 0
while. (#WJOBS__CJ)*.#CW-.BUSY do.
 rid__CW=: ''$;{.>{.WJOBS__CJ
 t=. ;{:>{.WJOBS__CJ
 echo 'WJOB: ';t
 WJOBS__CJ=: }.WJOBS__CJ
 BUSY=: BUSY,CW
 runa__CW '":,>{:{:jd''info summary''[jd jcs_p0';<t
end.
)

NB. get results from completed jobs
runzjobs=: 3 : 0
for_n. BUSY do.
 if. n e. y do.
  echo 'runz: ',;n
  BUSY=: BUSY-.n
  try.
   rs=. runz__n 0
   if. n=CW do. tlens=: rs end.
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
echo 'send result to client'
send S;SROUTE;(#SROUTE);ZMQ_SNDMORE
r=. send S;OUT;(#OUT);0
OUT=: r}.OUT
)

NB. run JOBS
mtm_run=: 3 : 0
RJOBS__CJ=: WJOBS__CJ=: JOBSTREAM__CJ=: OUT__CJ=: BUSY=: ''
pjclean''
while. 1 do.
  'rc reads writes errors'=. poll_jcs_ POLL;((1+2*0~:#OUT__CJ),1#~#BUSY);<CJ,BUSY
  if.  0=rc do. continue. end.
  getjobs__CJ reads NB. get jobs from client stream and move to JOBS 
  runWjobs''        NB. runa W jobs in idle CJ tasks
  runRjobs''        NB. runa R jobs in idle CRS tasks
  runzjobs reads    NB. runz to get results from completed jobs
  sendrs__CJ writes NB. send OUT to client
end.
)
